import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import "./App.css";
import VnpayResultScreen from "./pages/VnpayResult";
import HomeScreen from "./pages/Home";
import MomoResultScreen from "./pages/MomoResult";
import StripeSuccessResultScreen from "./pages/StripeSuccessResult";
import StripeCancelledResultScreen from "./pages/StripeCancelledResult";
import ConfirmEmailScreen from "./pages/ConfirmEmail";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<HomeScreen />} />
        <Route path="/vnpay-result" element={<VnpayResultScreen />} />
        <Route path="/momo-result" element={<MomoResultScreen />} />

        <Route
          path="/stripe-callback-success"
          element={<StripeSuccessResultScreen />}
        />
        <Route
          path="/stripe-callback-cancelled"
          element={<StripeCancelledResultScreen />}
        />

        <Route path="/confirm-email" element={<ConfirmEmailScreen />} />
      </Routes>
    </Router>
  );
}

export default App;
