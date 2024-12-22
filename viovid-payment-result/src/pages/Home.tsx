import { useState } from "react";
import reactLogo from "../assets/react.svg";
import viovidLogo from "../../../assets/images/viovid_logo_rgb.png";
import viteLogo from "/vite.svg";

const HomeScreen = () => {
  const [count, setCount] = useState(0);

  return (
    <>
      <h1 style={{ marginBottom: 12 }}>Trang chủ</h1>
      <a target="_blank">
        <img src={viovidLogo} width={200} style={{ marginBottom: 30 }} />
      </a>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
      </div>
    </>
  );
};

export default HomeScreen;
