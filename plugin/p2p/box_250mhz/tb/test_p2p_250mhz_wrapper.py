import itertools
import logging

import cocotb
from cocotb.clock import Clock
from cocotb.regression import TestFactory
from cocotb.triggers import RisingEdge
from cocotbext.axi import (AxiLiteBus, AxiLiteMaster, AxiStreamBus,
                           AxiStreamFrame, AxiStreamSink, AxiStreamSource)
from scapy.all import IP, UDP, Ether

# UDP packet with 128B payload
PACKET = Ether(src='aa:bb:cc:dd:ee:ff', dst='11:22:33:44:55:66') \
    / IP(src='1.1.1.1', dst='2.2.2.2') \
    / UDP(sport=11111, dport=22222) / (b'\xaa'*128)


class TB:
    def __init__(self, dut):
        self.dut = dut

        self.log = logging.getLogger("cocotb.tb")
        self.log.setLevel(logging.DEBUG)
        self.log.info("Got DUT: {}".format(dut))

        cocotb.fork(Clock(dut.axis_aclk, 2, units="ns").start())
        cocotb.fork(Clock(dut.axil_aclk, 4, units="ns").start())

        # Note, cocotb by default assumes reset signals are active high, while
        # open nic shell has reset signals active low. This is why we pass
        # reset_active_level=False.
        self.source_tx = [AxiStreamSource(
            AxiStreamBus.from_prefix(
                dut, "s_axis_qdma_h2c_port{}".format(port)),
            dut.axis_aclk, dut.p2p_250mhz_inst.axil_aresetn,
            reset_active_level=False)
            for port in [0, 1]]
        self.source_rx = [AxiStreamSource(
            AxiStreamBus.from_prefix(
                dut, "s_axis_adap_rx_250mhz_port{}".format(port)),
            dut.axis_aclk, dut.p2p_250mhz_inst.axil_aresetn,
            reset_active_level=False)
            for port in [0, 1]]
        self.sink_tx = [AxiStreamSink(
            AxiStreamBus.from_prefix(
                dut, "m_axis_adap_tx_250mhz_port{}".format(port)),
            dut.axis_aclk, dut.p2p_250mhz_inst.axil_aresetn,
            reset_active_level=False)
            for port in [0, 1]]
        self.sink_rx = [AxiStreamSink(
            AxiStreamBus.from_prefix(
                dut, "m_axis_qdma_c2h_port{}".format(port)),
            dut.axis_aclk, dut.p2p_250mhz_inst.axil_aresetn,
            reset_active_level=False)
            for port in [0, 1]]
        self.control = AxiLiteMaster(
            AxiLiteBus.from_prefix(dut, "s_axil"),
            dut.axil_aclk, dut.p2p_250mhz_inst.axil_aresetn,
            reset_active_level=False)

    def set_idle_generator(self, generator=None):
        if generator:
            for source_tx in self.source_tx:
                source_tx.set_pause_generator(generator())

    def set_backpressure_generator(self, generator=None):
        if generator:
            for sink_tx in self.sink_tx:
                sink_tx.set_pause_generator(generator())

    async def reset(self):
        self.dut.mod_rstn.setimmediatevalue(1)
        # mod rst signals are synced with the axi_aclk
        await RisingEdge(self.dut.axil_aclk)
        await RisingEdge(self.dut.axil_aclk)
        self.dut.mod_rstn.value = 0
        await RisingEdge(self.dut.axil_aclk)
        await RisingEdge(self.dut.axil_aclk)
        self.dut.mod_rstn.value = 1
        await RisingEdge(self.dut.mod_rst_done)


async def check_connection(
        tb: TB, source: AxiStreamSource,
        sink: AxiStreamSink, test_packet=PACKET):
    # Pkts on source should arrive at sink
    test_frames = []
    test_frame = AxiStreamFrame(bytes(test_packet), tuser=0)
    await source.send(test_frame)
    test_frames.append(test_frame)
    tb.log.info("Frame sent")

    for test_frame in test_frames:
        tb.log.info("Trying to recv frame")
        rx_frame = await sink.recv()
        assert rx_frame.tdata == test_frame.tdata

    assert sink.empty()


async def run_test(dut, idle_inserter=None, backpressure_inserter=None):

    tb = TB(dut)

    await tb.reset()

    tb.set_idle_generator(idle_inserter)
    tb.set_backpressure_generator(backpressure_inserter)

    await check_connection(tb, tb.source_tx[0], tb.sink_tx[0], PACKET)
    await check_connection(tb, tb.source_tx[1], tb.sink_tx[1], PACKET)
    await check_connection(tb, tb.source_rx[0], tb.sink_rx[0], PACKET)
    await check_connection(tb, tb.source_rx[1], tb.sink_rx[1], PACKET)

    # Due to some bugs in cocotb following lines are needed.
    # Check cocotb gitter for details.
    await RisingEdge(dut.axis_aclk)
    await RisingEdge(dut.axis_aclk)


def cycle_pause():
    return itertools.cycle([1, 1, 1, 0])


if cocotb.SIM_NAME:
    factory = TestFactory(run_test)
    factory.add_option("idle_inserter", [None, cycle_pause])
    factory.add_option("backpressure_inserter", [None, cycle_pause])
    factory.generate_tests()
