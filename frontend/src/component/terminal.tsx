import { Terminal } from "xterm";
import { FitAddon } from "xterm-addon-fit";
import { WebLinksAddon } from "xterm-addon-web-links";
import { SearchAddon } from "xterm-addon-search";
import { io } from "socket.io-client";
import { useRef, useEffect } from "react";
import "./Termainal.css";
import "xterm/css/xterm.css";
type Props = {};

export default function MyTerminal({ }: Props) {
  const TerminalRef = useRef<HTMLDivElement>(null);

  // debugger;
  const term = new Terminal({
    cursorBlink: true,

    macOptionIsMeta: true,
    scrollback: 1,
  });
  term.attachCustomKeyEventHandler(customKeyEventHandler);
  const fit = new FitAddon();
  term.loadAddon(fit);
  term.loadAddon(new WebLinksAddon());
  term.loadAddon(new SearchAddon());

  const socket = io("localhost:5000/pty");
  useEffect(() => {
    term.open(TerminalRef.current as HTMLDivElement);
    term.resize(150, 30);
  }, []);
  useEffect(() => {
    return () => {
      socket.disconnect(), [];
    };
  });
  fit.fit();
  console.log(`size: ${term.cols} columns, ${term.rows} rows`);
  //fit.fit();

  term.onData((data) => {
    console.log("browser terminal received new data:", data);
    socket.emit("pty-input", { input: data });
  });

  socket.on("pty-output", function(data) {
    console.log("new output received from server:", data.output);
    term.write(data.output);
    console.log(data.output);
  });
  socket.on("connect", () => {
    // TODO: set connect on in react
  });
  socket.on("disconnect", () => { });

  // function debounce(func:any, wait_ms:Number) {
  //   let timeout:any;
  //   return function(...args:any) {
  //     const context = this;
  //     clearTimeout(timeout);
  //     timeout = setTimeout(() => func.apply(context, args), wait_ms);
  //   };
  // }
  function customKeyEventHandler(e: any) {
    if (e.type !== "keydown") {
      return true;
    }
    if (e.ctrlKey && e.shiftKey) {
      const key = e.key.toLowerCase();
      if (key === "v") {
        // ctrl+shift+v: paste whatever is in the clipboard
        navigator.clipboard.readText().then((toPaste) => {
          //term.writeText(toPaste);
        });
        return false;
      } else if (key === "c" || key === "x") {
        const toCopy = term.getSelection();
        navigator.clipboard.writeText(toCopy);
        term.focus();
        return false;
      }
    }
    return true;
  }
  //const wait_ms = 50;
  //window.onresize = () => fitToscreen();
  return (
    <div
      style={{
        position: "static",
        width: "100%",
        height: "10rem",
      }}
    >
      <div
        style={{
          position: "relative",
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
        }}
        ref={TerminalRef}
      ></div>
    </div>
  );
}
