`include "macro.v"
module ex(
    input wire rst,

    input wire[`ALUOPBUS]  aluop_i,
    input wire[`ALUSELBUS] alusel_i,
    input wire[`REGBUS]  reg1_i,
    input wire[`REGBUS]  reg2_i,
    input wire[`REGADDRBUS]  wd_i,
    input wire  wreg_i,

    output reg[`REGADDRBUS]  wd_o,
    output reg  wreg_o,
    output reg[`REGBUS] wdata_o
);

    reg[`REGBUS] logicout;
	 reg[`REGBUS] shiftres;

    always @(*) begin
        if (rst == `RSTENABLE) begin
            logicout <= `ZEROWORD;
        end else begin 
            case (aluop_i)
                `EXE_OR_OP: begin 
                    logicout <= reg1_i | reg2_i;
                end
					 
					 `EXE_AND_OP: begin
						  logicout <= reg1_i & reg2_i;
					 end
					 
					 `EXE_NOR_OP: begin
						  logicout <= ~(reg1_i | reg2_i);
					 end
					 
					 `EXE_XOR_OP: begin
						  logicout <= reg1_i ^ reg2_i;
					 end
					 
                default: begin 
                    logicout <= `ZEROWORD;
                end
					 
            endcase 
        end
    end
	 
	 
	 always @(*) begin
		if (rst == `RSTENABLE) begin
			shiftres <= `ZEROWORD;
		end else begin
			case (aluop_i)
				`EXE_SLL_OP: begin
					shiftres <= reg2_i << reg1_i[4:0];
				end
				
				`EXE_SRL_OP: begin
					shiftres <= reg2_i >> reg1_i[4:0];
				end
				
				`EXE_SRA_OP: begin
					shiftres <= $signed(reg2_i) >>> reg1_i[4:0];
				end
				
				default: begin
					shiftres <= `ZEROWORD;
				end
			endcase
		end
	end
	 

    always @(*) begin 
        wd_o <= wd_i;
        wreg_o <= wreg_i;
        case (alusel_i)
            `EXE_RES_LOGIC: begin
                wdata_o <= logicout;
            end
				`EXE_RES_SHIFT: begin
					 wdata_o <= shiftres;
				end
            default: begin
                wdata_o <= `ZEROWORD;
            end
        endcase
    end 

endmodule
