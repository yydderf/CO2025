library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RunningSevenSegment is
   port (
     Clk              : in  std_logic;
     Reset            : in  std_logic;
     Disable          : in  std_logic;
     SevenSegment     : out std_logic_vector(7 downto 0);
     DP               : out std_logic
   );
end RunningSevenSegment;

architecture Behavioral of RunningSevenSegment is
   -- Internal signals
   signal count      : unsigned(3 downto 0) := "0000";
   signal seg_signal : std_logic_vector(7 downto 0);
   signal slow_clk   : std_logic := '0';
   signal clk_divider: integer := 0;
   signal disabled   : std_logic := '0';

begin

   clock_divider_process: process(Clk, Reset)
   begin
     if Reset = '1' then
        clk_divider <= 0;
        slow_clk <= '0';
     elsif rising_edge(Clk) then
        if clk_divider >= 666666 then  -- approximately 3333333 for 15 Hz
           slow_clk <= not slow_clk;
           clk_divider <= 0;
        else
           clk_divider <= clk_divider + 1;
        end if;
     end if;
   end process;

   disable_process: process(Clk, Disable, Reset)
   begin
     if Reset = '1' then
        disabled <= '0';
     elsif rising_edge(Clk) then
        if Disable = '1' then
            disabled <= '1';
        end if;
     end if;
   end process;

   counter_process: process(slow_clk, Reset)
   begin
     if Reset = '1' then
        count <= "0000"; -- Reset count to 0
     elsif rising_edge(slow_clk) then
        if count = 5 then
          count <= "0000"; -- Reset to 0 after 5
        else
          count <= count + 1; -- Increment count
        end if;
     end if;
   end process;

   display_process: process(count, disabled)
   begin
     if disabled = '1' then
       seg_signal <= "11111110";
     else
       case count is
         when "0000" => seg_signal <= "11111101"; -- 0
         when "0001" => seg_signal <= "11111011"; -- 1
         when "0010" => seg_signal <= "11110111"; -- 2
         when "0011" => seg_signal <= "11101111"; -- 3
         when "0100" => seg_signal <= "11011111"; -- 4
         when "0101" => seg_signal <= "10111111"; -- 5
         when others => seg_signal <= "00000001";
       end case;
     end if;
   end process;

   -- Assign output
   SevenSegment <= seg_signal;
   DP <= '1'; -- DP off
end Behavioral;
