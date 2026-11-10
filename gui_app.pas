program ModernGuiApp;

{$mode objfpc}{$H+}{$apptype gui}

uses
  Windows, Messages, SysUtils;

const
  ClassName = 'ModernPascalWindowClass';

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

        if LOWORD(WParam) = 1 then 
          MessageBox(Window, 'Hello World!', 'Greetings', MB_OK or MB_ICONINFORMATION);
      end;
  end;
  Result := DefWindowProc(Window, Msg, WParam, LParam);
end;


var
  WindowClass: TWndClass;
  WindowHandle: HWND;
  ButtonHandle: HWND;
  Msg: TMsg;
  x: integer;
  y: integer;

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
    CW_USEDEFAULT, CW_USEDEFAULT, 300,400,
    0, 0, HInstance, nil
  );

  if WindowHandle = 0 then Halt;

  for y := 0 to 3 do
    for x:= 0 to 3 do 
      begin
        begin
          ButtonHandle := CreateWindow(
            'BUTTON', 'Click Me',
            WS_VISIBLE or WS_CHILD or BS_DEFPUSHBUTTON,
            60 * x, 120 + (60 * y), 60, 60,
            WindowHandle, HMENU(1), HInstance, nil
          );
        end;
      end;










  while GetMessage(Msg, 0, 0, 0) do
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end.
