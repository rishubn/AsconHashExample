-------------------------------------------------------------------------------
-- Title      : Testbench for design "AsconHash"
-- Project    :
-------------------------------------------------------------------------------
-- File       : AsconHash_tb.vhd
-- Author     : Rishub Nagpal  <rnagpal2@gmu.edu>
-- Company    :
-- Created    : 2021-12-10
-- Last update: 2021-12-10
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-12-10  1.0      rishub	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.AsconHash_pkg.all;
-------------------------------------------------------------------------------

entity AsconHash_tb is

end entity AsconHash_tb;

-------------------------------------------------------------------------------

architecture tb of AsconHash_tb is

  -- component ports
  signal clk     : std_logic := '1';
  signal rst     : std_logic;
  signal in_bus  : data_in_t;
  signal out_bus : data_out_t;

  -- clock

begin  -- architecture tb

  -- component instantiation
  DUT: entity work.AsconHash
    port map (
      clk     => clk,
      rst     => rst,
      in_bus  => in_bus,
      out_bus => out_bus);

  -- clock generation
  clk <= not clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here
    rst <= '1';
    in_bus.control.valid <= '0';
    in_bus.control.start <= '0';
    in_bus.control.last <= '0';
    in_bus.control.ready <= '0';
    wait for 20 ns;
    rst <= '0';
    wait for 10 ns;
    in_bus.control.start <= '1';
    in_bus.control.valid <= '1';
    in_bus.data <= x"0001020304050607";
    wait for 10 ns;
    in_bus.control.start <= '0';
    wait until out_bus.status.ready = '1';
    wait for 20 ns;
    in_bus.control.last <= '1';
    in_bus.data <= x"08090a0b0c0d0e0f";
    wait for 10 ns;
    in_bus.control.ready <= '1';
    in_bus.control.last <= '1';
    wait until out_bus.status.done = '1';
    in_bus.control.ready <= '0';
    wait for 100 ns;
   assert false report "Test: OK" severity failure;
  end process WaveGen_Proc;



end architecture tb;

-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
