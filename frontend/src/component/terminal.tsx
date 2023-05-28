import { Terminal } from "xterm";
import { FitAddon } from "xterm-addon-fit";
import { WebLinksAddon } from "xterm-addon-web-links";
import { SearchAddon } from "xterm-addon-search";
import { io } from "socket.io-client";
import { useRef, useEffect } from "react";
import "./Termainal.css";

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
  //const fit = new FitAddon();
  //term.loadAddon(fit);
  term.loadAddon(new WebLinksAddon());
  term.loadAddon(new SearchAddon());

  useEffect(() => {
    term.open(TerminalRef.current as HTMLDivElement);
  }, []);
  //fit.fit();
  term.resize(150, 150);
  console.log(`size: ${term.cols} columns, ${term.rows} rows`);
  //fit.fit();
  term.writeln("Welcome to Lucas's website");
  term.writeln("type help to see more");

  term.onData((data) => {
    console.log("browser terminal received new data:", data);
    socket.emit("pty-input", { input: data });
  });

  const socket = io("localhost:5000/pty");

  socket.on("pty-output", function(data) {
    console.log("new output received from server:", data.output);
    term.write(data.output);
  });
  socket.on("connect", () => {
    fitToscreen();
    // TODO: set connect on in react
  });
  socket.on("disconnect", () => { });
  function fitToscreen() {
    //fit.fit();
    const dims = { cols: 200, rows: 200 }; //{ cols: term.cols, rows: term.rows };
    console.log("sending new dimensions to server's pty", dims);
    socket.emit("resize", dims);
  }
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
  return <div ref={TerminalRef}></div>;
}
