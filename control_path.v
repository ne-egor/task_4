// Имена новых управляющих портов добавить после соответствующего комментария в первой строке объявления модуля.
// Сами объявления дописывать под соответствующим комментарием после имеющихся объявлений портов. Комментарий не стирать.
// Реализацию управляющего автомата дописывать под соответствующим комментарием в конце модуля. Комментарий не стирать.
// По необходимости можно раскомментировать ключевые слова "reg" в объявлениях портов.
module control_path(on, start, regime, active, y_select_next, s_step, y_en, s_en, y_store_x, s_add, s_zero, clk, rst, 
      y_inc    /* , ... (ИМЕНА НОВЫХ УПРАВЛЯЮЩИХ ПОРТОВ */);
  
  input [1:0] on;
  input start, clk, rst;
  
  output reg [1:0] regime;
  output reg active;
  output reg [1:0] y_select_next;
  output reg [1:0] s_step;
  output reg y_en;
  output reg s_en;
  output reg y_store_x;
  output reg s_add;
  output reg s_zero;
  
  /* ОБЪЯВЛЕНИЯ НОВЫХ УПРАВЛЯЮЩИХ ПОРТОВ */
  input y_inc;


  localparam S_OFF = 0, S_ELIST = 1, S_CNT = 2, S_UPDATE = 3;
  localparam S_6 = S_ELIST + 4,
             S_4_PRE = S_ELIST + 8, 
             S_4 = S_ELIST + 12,
             S_2_PRE = S_ELIST + 16,
             S_2 = S_ELIST + 20,
             S_0_PRE = S_ELIST + 24,
             S_0 = S_ELIST + 28,
             

             S_UP_2 = S_UPDATE + 4,
             S_UP_3 = S_UPDATE + 8,
             S_UP_F = S_UPDATE + 12;
  
  reg [7:0] state; 
  //reg [3:0] state;

  reg [1:0] timer, next_timer;
  
  /* КОД УПРАВЛЯЮЩЕГО АВТОМАТА */
  // assign regime = state;
  // assign real_state = state;


  always @(posedge clk, posedge rst) begin
    regime <= state;
    if (rst) begin
      state <= S_OFF;
      timer <= 0;
      active <= 0;
    end else if (timer == 0) begin
      //state <= state;
      case (state)
        S_OFF: begin 
          state <= on;
          s_en <= 0;
          y_en <= 0;
        end
        S_ELIST: if (start == 1) begin
          //active <= 1;
          state <= S_6;
        end
        S_6: begin
          active <= 1;
          state <= S_4_PRE;
          //set s = 6;
          s_en <= 1;
          s_add <= 0;
          s_step <= 2;
          s_zero <= 1;
        end
        S_4_PRE: begin 
          state <= S_4;
          s_zero <= 0;
        end
        S_4: begin
          state <= S_2_PRE;
          s_en <= 0; 
        end
        S_2_PRE: begin 
          state <= S_2;
          s_en <= 1;
        end
        S_2: begin
          state <= S_0_PRE;
          s_en <= 0; 
        end
        S_0_PRE: begin
          state <= S_0;
          s_zero <= 1;
          s_step <= 0;
          s_en <= 1;
        end
        S_0: begin
          s_en <= 1;
          s_add <= 0;
          s_step <= 2;
          s_zero <= 1;
          
          state <= S_OFF;
          active <= 0;

          // нужно выставить s = 6, мб новый state нужен
          //set s = 6;
        end
        S_CNT: if (start == 0)
          state <= S_OFF;
          else begin
          //s <= s + 1;
          s_zero <= 0;
          s_add <= 1;
          s_step <= 1;
          s_en <= 1;
          //if (s + 1) == 3   y <= y + 1
          if (y_inc) begin
            y_select_next <= 1;
            y_store_x <= 0;
            y_en <= 1;
          end else
            y_en <= 0;
        end

        S_UPDATE: begin
          y_store_x <= 1;
          y_en <= 1;
          state <= S_UP_2;
        end
        S_UP_2: begin
          y_store_x <= 0;
          y_select_next <= 2'd2;
          state <= S_UP_3;
        end
        S_UP_3: begin
          y_en <= 0;
          s_zero <= 0;
          s_step <= 1;
          s_add <= 0;
          s_en <= 1;

          state <= S_UP_F;
        end
        S_UP_F: begin
          s_en <= 0;
          state <= S_OFF;
        end
        default: state <= state;
      endcase // state
      timer <= next_timer;
      /*
      if (state == S_0) begin  /// <---- возможно ошибка, старый стейт
        s_en <= 1;
        s_add <= 0;
        s_step <= 2;
        s_zero <= 1;
      end
      */
    end else timer <= timer - 1;
  end


  //assign state = (state == S_OFF) ? on : (rst_state ? S_OFF : state);




  // вместо * мб state, или pos clk, или хз
  always @* begin
    next_timer = 0;
    if ((state == S_6) || (state == S_0_PRE)) next_timer = 2;
    if ((state == S_4) || (state == S_2)) next_timer = 1;
  end






endmodule
