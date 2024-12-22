import useSWR from "swr";
import { BASE_URL } from "../constants";
import axios, { AxiosResponse } from "axios";
import { ApiResult } from "../api_result";
import Loading from "../components/Loading";
import { useEffect, useState } from "react";

interface IStripeSuccessCallBackData {
  sessionId: string;
}

const fetcher = async (url: string, payload: IStripeSuccessCallBackData) => {
  const response = await axios.post<
    ApiResult<boolean>,
    AxiosResponse<ApiResult<boolean>>,
    IStripeSuccessCallBackData
  >(url, payload);
  return response.data; // Trả về phần data từ AxiosResponse
};

const handleRedirect = () => {
  window.location.href = "petrichor-viovid://deeplink-to-app";
  setTimeout(() => {
    // Di chuyển về trang chủ
    window.location.href = "http://192.168.1.6:5416/";
  }, 500);
};

const StripeCancelledResultScreen = () => {
  const currentUrl = window.location.href;

  // Parse query params
  const queryParams = new URLSearchParams(currentUrl.split("?")[1]);

  const payload: IStripeSuccessCallBackData = {
    sessionId: queryParams.get("sessionId") || "",
  };

  const { error, isValidating } = useSWR(
    [`${BASE_URL}/api/Payment/stripe-callback-cancelled`, payload],
    ([url, payload]: [string, IStripeSuccessCallBackData]) =>
      fetcher(url, payload),
    {
      revalidateOnFocus: false, // Không gọi lại API khi tab được focus
      revalidateOnReconnect: false, // Không gọi lại API khi mạng được khôi phục
    }
  );

  const [countdown, setCountdown] = useState<number>(10); // Ban đầu chưa bắt đầu countdown
  const [redirect, setRedirect] = useState(false); // Cờ điều hướng

  useEffect(() => {
    if (countdown < 0) return;

    const timer = setInterval(() => {
      setCountdown((prev) => prev - 1);
    }, 1000);

    console.log("countdown = " + countdown);
    if (countdown === 0) {
      setRedirect(true); // Kích hoạt điều hướng
      clearInterval(timer);
    }

    return () => clearInterval(timer);
  }, [countdown]);

  useEffect(() => {
    if (redirect) {
      handleRedirect();
    }
  }, [redirect]);

  if (error) return <h2 style={styles.errorMessage}>Có lỗi xảy ra</h2>;
  if (isValidating) return <Loading />;

  return (
    <div style={styles.container}>
      <p style={styles.successMessage}>
        Đã huỷ
        <br />
        Phiên thanh toán
      </p>
      <button style={styles.button} onClick={handleRedirect}>
        Trở về Viovid
      </button>
      {countdown !== null ? (
        <p>Sẽ trở lại ứng dụng sau {countdown} giây</p>
      ) : (
        <p>Đang chờ xác nhận từ API...</p>
      )}
    </div>
  );
};

const styles = {
  container: {
    padding: "20px",
    fontFamily: "Arial, sans-serif",
  },
  button: {
    backgroundColor: "#E50915", // Primary Viovid Color
    color: "white",
    border: "none",
    padding: "12px 24px",
    fontSize: "16px",
    cursor: "pointer",
    borderRadius: "8px",
  },
  successMessage: {
    fontSize: "24px",
    fontWeight: "bold",
    color: "#000",
    marginTop: "0px",
    marginBottom: "20px",
  },
  errorMessage: {
    fontSize: "24px",
    fontWeight: "bold",
    color: "#f00",
    marginBottom: "20px",
  },
};

export default StripeCancelledResultScreen;
