-- TrainController.vhd
-- VHDL of Train Controller State Machine
-- Richard Barrezueta
-- 06/26/2024

-- State machine to control trains
LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY TrainController IS
        PORT(
        reset, clock, sensor1, sensor2      : IN std_logic;
        sensor3, sensor4, sensor5, sensor6  : IN std_logic;
        switch1, switch2, switch3, switch4  : OUT std_logic;
        dirA, dirB                          : OUT std_logic_vector(1 DOWNTO 0)
);
END TrainController;


ARCHITECTURE a OF TrainController IS

        -- Enumerated states.
        -- 3-bit length state.
        TYPE STATE_TYPE IS (
        Acw_Bin,
        Accw_Bin,
        Acw_Bout,
        Ain_Bout,
        Accw_Bout,
        Ain_Bstop
);
SIGNAL state : STATE_TYPE;
SIGNAL sensor24, sensor26, sensor34, sensor36 : std_logic_vector(1 DOWNTO 0);

BEGIN
        PROCESS (clock, reset)
        BEGIN
                IF reset = '1' THEN
                        -- Reset
                        state <= Acw_Bin;
                ELSIF clock'EVENT AND clock = '1' THEN
                        -- Case statement to determine next state.
                        CASE state IS
                                WHEN Acw_Bin =>
                                        CASE Sensor24 IS
                                                WHEN "00" => state <= Acw_Bin;
                                                WHEN "01" => state <= Accw_Bin;
                                                WHEN "10" => state <= Acw_Bout;
                                                WHEN "11" => state <= Ain_Bout;
                                                WHEN OTHERS => state <= Acw_Bin;
                                        END CASE;

                                WHEN Accw_Bin =>
                                        CASE Sensor26 IS
                                                WHEN "00" => state <= Accw_Bin;
                                                WHEN "01" => state <= Acw_Bin;
                                                WHEN "10" => state <= Accw_Bout;
                                                WHEN "11" => state <= Acw_Bin;
                                                WHEN OTHERS => state <= Accw_Bin;
                                        END CASE;

                                WHEN Acw_Bout =>
                                        CASE Sensor34 IS
                                                WHEN "00" => state <= Acw_Bout;
                                                WHEN "01" => state <= Ain_Bout;
                                                WHEN "10" => state <= Acw_Bin;
                                                WHEN "11" => state <= Ain_Bstop;
                                                WHEN OTHERS => state <= Acw_Bout;
                                        END CASE;

                                WHEN Ain_Bout =>
                                        CASE Sensor36 IS
                                                WHEN "00" => state <= Ain_Bout;
                                                WHEN "01" => state <= Acw_Bout;
                                                WHEN "10" => state <= Ain_Bstop;
                                                WHEN "11" => state <= Acw_Bin;
                                                WHEN OTHERS => state <= Ain_Bout;
                                        END CASE;

                                WHEN Accw_Bout =>
                                        CASE Sensor36 IS
                                                WHEN "00" => state <= Accw_Bout;
                                                WHEN "01" => state <= Acw_Bout;
                                                WHEN "10" => state <= Accw_Bin;
                                                WHEN "11" => state <= Acw_Bin;
                                                WHEN OTHERS => state <= Accw_Bout;
                                        END CASE;

                                WHEN Ain_Bstop =>
                                        CASE Sensor36 IS
                                                WHEN "00" => state <= Ain_Bstop;
                                                WHEN "01" => state <= Acw_Bin;
                                                WHEN "10" => state <= Ain_Bstop;
                                                WHEN "11" => state <= Acw_Bin;
                                                WHEN OTHERS => state <= Acw_Bin;
                                        END CASE;

                        END CASE;
                END IF;
        END PROCESS;

        -- Combine bits for the internal signals declared above.
        sensor24 <= sensor2 & sensor4;
        sensor26 <= sensor2 & sensor6;
        sensor34 <= sensor3 & sensor4;
        sensor36 <= sensor3 & sensor6;

        -- The following switches depend on the state.
        WITH state SELECT Switch3 <=
        '0' WHEN Acw_Bin,
        '0' WHEN Accw_Bin,
        '0' WHEN Acw_Bout,
        '1' WHEN Ain_Bout,
        '0' WHEN Accw_Bout,
        '1' WHEN Ain_Bstop;
        WITH state SELECT Switch4 <=
        '0' WHEN Acw_Bin,
        '0' WHEN Accw_Bin,
        '0' WHEN Acw_Bout,
        '1' WHEN Ain_Bout,
        '0' WHEN Accw_Bout,
        '1' WHEN Ain_Bstop;
        WITH state SELECT DirA <=
        "10" WHEN Acw_Bin,
        "01" WHEN Accw_Bin,
        "10" WHEN Acw_Bout,
        "01" WHEN Ain_Bout,
        "01" WHEN Accw_Bout,
        "01" WHEN Ain_Bstop;
        WITH state SELECT DirB <=
        "01" WHEN Acw_Bin,
        "01" WHEN Accw_Bin,
        "01" WHEN Acw_Bout,
        "01" WHEN Ain_Bout,
        "01" WHEN Accw_Bout,
        "00" WHEN Ain_Bstop;

        -- Constant switches.
        Switch1 <= '1';
        Switch2 <= '1';
END a;
