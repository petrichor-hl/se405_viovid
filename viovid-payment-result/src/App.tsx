import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import "./App.css";
import VnpayResultScreen from "./pages/VnpayResult";
import HomeScreen from "./pages/Home";

// vite --host 192.168.1.8 --port 5416

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomeScreen />} />
        <Route path="/vnpay-result" element={<VnpayResultScreen />} />
      </Routes>
    </Router>
  );
}

export default App;
