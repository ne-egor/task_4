// Имена новых управляющих портов добавить после соответствующего комментария в первой строке объявления модуля.
// Сами объявления дописывать под соответствующим комментарием после имеющихся объявлений портов. Комментарий не стирать.
// Реализацию управляющего автомата дописывать под соответствующим комментарием в конце модуля. Комментарий не стирать.
// По необходимости можно раскомментировать ключевые слова "reg" в объявлениях портов.
module control_path(on, start, regime, active, y_select_next, s_step, y_en, s_en, y_store_x, s_add, s_zero, clk, rst 
            /* , ... (ИМЕНА НОВЫХ УПРАВЛЯЮЩИХ ПОРТОВ */);
  
  input [1:0] on;
  input start, clk, rst;
  
  output /* reg */ [1:0] regime;
  output /* reg */ active;
  output /* reg */ [1:0] y_select_next;
  output /* reg */ [1:0] s_step;
  output /* reg */ y_en;
  output /* reg */ s_en;
  output /* reg */ y_store_x;
  output /* reg */ s_add;
  output /* reg */ s_zero;
  
  /* ОБЪЯВЛЕНИЯ НОВЫХ УПРАВЛЯЮЩИХ ПОРТОВ */
  localparam S_OFF = 0, S_ELIST = 1, S_CNT = 2, S_UPDATE = 3;
  localparam S_6, S_4, S_2, S_0;
  reg state; 
  wire next_state;
  wire rst_state
  // reg [2:0] timer, next_timer;
  
  /* КОД УПРАВЛЯЮЩЕГО АВТОМАТА */

  always @(posedge clk)
    if (rst) begin
      state <= S_OFF;
    end else
      state <= next_state;


  assign next_state = (state == S_OFF) ? on : (rst_state ? S_OFF : state);
  assign regime = state;

  





endmodule
