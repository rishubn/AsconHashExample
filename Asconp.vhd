library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Asconp is
    port (
        state_in : in std_logic_vector(319 downto 0);
        round_c : in std_logic_vector(3 downto 0);
        state_out : out std_logic_vector(319 downto 0)
    );
end entity Asconp;

architecture rtl of Asconp is
    signal rc : std_logic_vector(7 downto 0);
    signal rc1 : std_logic_vector(7 downto 0);
begin
    rc <= std_logic_vector(
              to_unsigned(4, 4) + unsigned(round_c)) &
          std_logic_vector(
              to_unsigned(11, 4) - unsigned(round_c));

    rc1 <= std_logic_vector(
              to_unsigned(4, 4) + (unsigned(round_c)-1)) &
          std_logic_vector(
              to_unsigned(11, 4) - (unsigned(round_c)-1));
    process(all)
        variable x0,x1,x2,x3,x4 : std_logic_vector(63 downto 0);
        variable t0, t1 : std_logic_vector(63 downto 0);
    begin
        x4 := state_in(63 downto 0);
        x3 := state_in(64*2 -1 downto 64);
        x2 := state_in(64*3 -1 downto 2*64);
        x1 := state_in(64*4 -1 downto 3*64);
        x0 := state_in(64*5 -1 downto 4*64);

        x0 := x0 xor x4;
        x2(7 downto 0) := x2(7 downto 0) xor rc;
        x2 := x2 xor x1;
        x4 := x4 xor x3;

        t0 := x0;
        t1 := x1;
        x0 := x0 xor (not x1 and x2);
        x1 := x1 xor (not x2 and x3);
        x2 := x2 xor (not x3 and x4);
        x3 := x3 xor (not x4 and t0);
        x4 := x4 xor (not t0 and t1);

        x1 := x1 xor x0;
        x3 := x3 xor x2;
        x0 := x0 xor x4;
        x2 := not x2;

        x0 := x0 xor (x0(18 downto 0) & x0(63 downto 19)) xor (x0(27 downto 0) & x0(63 downto 28));
		x1 := x1 xor (x1(60 downto 0) & x1(63 downto 61)) xor (x1(38 downto 0) & x1(63 downto 39));
		x2 := x2 xor (x2(0 downto 0) & x2(63 downto 1)) xor (x2(5 downto 0) & x2(63 downto 6));
		x3 := x3 xor (x3(9 downto 0) & x3(63 downto 10)) xor (x3(16 downto 0) & x3(63 downto 17));
		x4 := x4 xor (x4(6 downto 0) & x4(63 downto 7)) xor (x4(40 downto 0) & x4(63 downto 41));
-- uncomment for 1 round
        x0 := x0 xor x4;
        x2(7 downto 0) := x2(7 downto 0) xor rc1;
        x2 := x2 xor x1;
        x4 := x4 xor x3;

        t0 := x0;
        t1 := x1;
        x0 := x0 xor (not x1 and x2);
        x1 := x1 xor (not x2 and x3);
        x2 := x2 xor (not x3 and x4);
        x3 := x3 xor (not x4 and t0);
        x4 := x4 xor (not t0 and t1);

        x1 := x1 xor x0;
        x3 := x3 xor x2;
        x0 := x0 xor x4;
        x2 := not x2;

        x0 := x0 xor (x0(18 downto 0) & x0(63 downto 19)) xor (x0(27 downto 0) & x0(63 downto 28));
		x1 := x1 xor (x1(60 downto 0) & x1(63 downto 61)) xor (x1(38 downto 0) & x1(63 downto 39));
		x2 := x2 xor (x2(0 downto 0) & x2(63 downto 1)) xor (x2(5 downto 0) & x2(63 downto 6));
		x3 := x3 xor (x3(9 downto 0) & x3(63 downto 10)) xor (x3(16 downto 0) & x3(63 downto 17));
		x4 := x4 xor (x4(6 downto 0) & x4(63 downto 7)) xor (x4(40 downto 0) & x4(63 downto 41));

        state_out(63 downto 0) <= x4;
        state_out(64*2 -1 downto 64) <= x3;
        state_out(64*3 -1 downto 2*64) <= x2;
        state_out(64*4 -1 downto 3*64) <= x1;
        state_out(64*5 -1 downto 4*64) <= x0;
    end process;
end architecture rtl;
