program ModernGuiApp;

{$mode objfpc}{$H+}{$apptype gui}

uses
  Windows, Messages, SysUtils;

const
  ClassName = 'ModernPascalWindowClass';


var
  WindowClass: TWndClass;
  WindowHandle: HWND;
  ButtonHandle: array [0..4,0..03] of HWND;
  DisplayHandle: HWND;
  Msg: TMsg;
  x: integer;
  y: integer;
  i: integer;
  keyText: array [0..4, 0..3] of String;
  equation : String;




procedure calculate();
var
  openingBrackets : integer;
  closingBrackets : integer;
begin

  for i := 0 to Length(equation) do
    begin
      if (equation[i] in ['+', '=', '.', '/', '*']) and
        (equation[i + 1] in ['+', '=', '.', '/', '*']) then
      begin
          equation := 'SYNTAX ERROR';
          SetWindowText(DisplayHandle,PChar(equation));
          Exit;
      end;

      if(equation[i] = '(') then
        begin
          openingBrackets := openingBrackets + 1;
        end;
      if(equation[i] = ')') then
        begin
          closingBrackets := closingBrackets + 1;
        end;
    end;

    if (openingBrackets <> closingBrackets) then
      begin
        equation := 'SYNTAX ERROR';
        SetWindowText(DisplayHandle,PChar(equation));
        Exit;
      end;

end;
function WindowProc(Window: HWND; Msg: UINT; WParam: WPARAM; LParam: LPARAM): LRESULT; stdcall;
begin
  case Msg of
    WM_DESTROY:
      begin
        PostQuitMessage(0);
        Exit(0);
      end;
    WM_COMMAND:
      begin
        for i := 0 to 19 do
          begin
            if LOWORD(WParam) = i then
              if i = 18 then 
                begin//equals sign
                  calculate();
                end

              else if i = 2 then
                begin
                  Delete(equation, Length(equation), 1);
                end

              else if i = 3 then
                begin 
                  equation := '';
                end
              
              else
                begin
                   equation := equation + keyText[i div 4, i mod 4];
                end;
      
              SetWindowText(DisplayHandle,PChar(equation));
          end;

      end;
  end;
  Result := DefWindowProc(Window, Msg, WParam, LParam);
end;


begin
  FillChar(WindowClass, SizeOf(WindowClass), 0);
  WindowClass.lpfnWndProc := @WindowProc;
  WindowClass.hInstance := HInstance;
  WindowClass.lpszClassName := ClassName;
  WindowClass.hbrBackground := COLOR_WINDOW;
  WindowClass.hCursor := LoadCursor(0, IDC_ARROW);

  if RegisterClass(WindowClass) = 0 then Halt;

  
  WindowHandle := CreateWindowEx(
    0, ClassName, 'PasCalc',
    WS_OVERLAPPEDWINDOW or WS_VISIBLE,
    CW_USEDEFAULT, CW_USEDEFAULT, 300,500,
    0, 0, HInstance, nil
  );

  if WindowHandle = 0 then Halt;
  equation := '';
  keyText[0,0] := '(';
  keyText[0,1] := ')';
  keyText[0,2] := 'DEL';
  keyText[0,3] := 'CE';
  keyText[1,0] := '1';
  keyText[1,1] := '2';
  keyText[1,2] := '3';
  keyText[1,3] := '/';
  keyText[2,0] := '4';
  keyText[2,1] := '5';
  keyText[2,2] := '6';
  keyText[2,3] := '*';
  keyText[3,0] := '7';
  keyText[3,1] := '8';
  keyText[3,2] := '9';
  keyText[3,3] := '-';
  keyText[4,0] := '0';
  keyText[4,1] := '.';
  keyText[4,2] := '=';
  keyText[4,3] := '+';
  
  DisplayHandle := CreateWindow(
            'STATIC', PChar(equation),
            WS_VISIBLE or WS_CHILD,
            0, 0, 300, 70,
            WindowHandle, HMENU(21), HInstance, nil
          );

  for y := 0 to 4 do
    for x:= 0 to 3 do 
      begin
        begin
          ButtonHandle[y,x] := CreateWindow(
            'BUTTON', PChar(keyText[y,x]),
            WS_VISIBLE or WS_CHILD or BS_DEFPUSHBUTTON,
            70 * x, 120 + (60 * y), 70, 60,
            WindowHandle, HMENU(y *4 + (x)), HInstance, nil
          );
        end;
      end;

  while GetMessage(Msg, 0, 0, 0) do
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end.
