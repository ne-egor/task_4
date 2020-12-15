// Имена новых управляющих портов добавить после соответствующего комментария в первой строке объявления модуля.
// Сами объявления дописывать под соответствующим комментарием после имеющихся объявлений портов. Комментарий не стирать.
// Реализацию управляющего автомата дописывать под соответствующим комментарием в конце модуля. Комментарий не стирать.
// По необходимости можно раскомментировать ключевые слова "reg" в объявлениях портов.
module control_path(on, start, regime, active, y_select_next, s_step, y_en, s_en, y_store_x, s_add, s_zero, clk, rst 
            /* , ... (ИМЕНА НОВЫХ УПРАВЛЯЮЩИХ ПОРТОВ */);
  
  input [1:0] on;
  input start, clk, rst;
  
  output [1:0] regime;
  output reg active;
  output reg [1:0] y_select_next;
  output reg [1:0] s_step;
  output reg y_en;
  output reg s_en;
  output reg y_store_x;
  output reg s_add;
  output reg s_zero;
  
  /* ОБЪЯВЛЕНИЯ НОВЫХ УПРАВЛЯЮЩИХ ПОРТОВ */
  localparam S_OFF = 0, S_ELIST = 1, S_CNT = 2, S_UPDATE = 3;
  localparam S_6 = S_ELIST + 4, 
             S_4 = S_ELIST + 8,
             S_2 = S_ELIST + 12,
             S_0 = S_ELIST + 16,

             S_UP_2 = S_UPDATE + 4,
             S_UP_3 = S_UPDATE + 8;
  reg [1:0] state; 
  reg [1:0] next_state;
  wire rst_state;
  reg [1:0] timer, next_timer;
  
  /* КОД УПРАВЛЯЮЩЕГО АВТОМАТА */

  always @(posedge clk, posedge rst)
    if (rst) begin
      state <= S_OFF;
      timer <= 0;
    end else if (timer == 0) begin
      state <= next_state;
      timer <= next_timer;
    end else timer <= timer - 1;


  //assign next_state = (state == S_OFF) ? on : (rst_state ? S_OFF : state);
  always @* begin
    case (state)
      S_OFF: next_state <= on;
      S_ELIST: if (start == 1) begin
        active <= 1;
        next_state <= S_6;
      end
      S_6: begin
        next_state <= S_4;
        //set s = 6;
        s_en <= 1;
        s_add <= 0;
        s_step <= 2;
        s_zero <= 1;
      end
      S_4: begin
        next_state <= S_2;
        //set s = 4;
        // !!! only modify 6 to 4, mb change @* (ubrat timer), inache neskolko raz povtorit modif
        // !!!!!!!!!!!!!!!!!!
        s_zero <= 0; 
      end
      S_2: begin
        next_state <= S_0;
        //set s = 6;
      end
      S_0: begin
        next_state <= S_OFF;
        active <= 0;

        // нужно выставить s = 6, мб новый state нужен
        //set s = 6;
      end
      S_CNT: if (start == 0)
        next_state <= S_OFF;
        else begin
        //s <= s + 1;
        //if (s + 1) == 3   y <= y + 1
      end
      S_UPDATE: begin
        y_store_x <= 1;
        y_en <= 1;
        next_state <= S_UP_2;
      end
      S_UP_2: begin
        y_store_x <= 0;
        y_select_next <= 2'd2;
        next_state <= S_UP_3;
      end
      S_UP_3: begin
        y_en <= 0;
        s_zero <= 0;
        s_step <= 1;
        s_add <= 0;

        next_state <= S_OFF;
      end
      default: next_state <= state;
    endcase // state


  end




  assign regime = state;

  always @* begin
    next_timer = 0;
    if ((state % 4 == S_ELIST) && (state != S_ELIST)) next_timer = 3;
  end






endmodule
