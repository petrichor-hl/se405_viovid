import useSWR from "swr";
import { BASE_API_URL, BASE_URL } from "../constants";
import axios, { AxiosResponse } from "axios";
import rubySparkles from "../../../assets/images/ruby_sparkles.png";
import { ApiResult } from "../api_result";
import Loading from "../components/Loading";
import { useEffect, useState } from "react";

interface IMomoCallBackData {
  paymentId: string;
  resultCode: number;
  amount: number;
}

const fetcher = async (url: string, payload: IMomoCallBackData) => {
  const response = await axios.post<
    ApiResult<boolean>,
    AxiosResponse<ApiResult<boolean>>,
    IMomoCallBackData
  >(url, payload);
  return response.data; // Trả về phần data từ AxiosResponse
};

const handleRedirect = () => {
  window.location.href = "petrichor-viovid://deeplink-to-app";
  setTimeout(() => {
    // Di chuyển về trang chủ
    window.location.href = BASE_URL;
  }, 500);
};

const MomoResultScreen = () => {
  const currentUrl = window.location.href;

  // Parse query params
  const queryParams = new URLSearchParams(currentUrl.split("?")[1]);

  console.log(queryParams);

  const payload: IMomoCallBackData = {
    paymentId: queryParams.get("orderId") || "",
    resultCode: Number(queryParams.get("resultCode") ?? -1),
    amount: Number(queryParams.get("amount")),
  };

  console.log(payload);

  const { data, error, isValidating } = useSWR(
    [`${BASE_API_URL}/Payment/momo-callback`, payload],
    ([url, payload]: [string, IMomoCallBackData]) => fetcher(url, payload),
    {
      revalidateOnFocus: false, // Không gọi lại API khi tab được focus
      revalidateOnReconnect: false, // Không gọi lại API khi mạng được khôi phục
    }
  );

  const [countdown, setCountdown] = useState<number | undefined>(); // Ban đầu chưa bắt đầu countdown
  const [redirect, setRedirect] = useState(false); // Cờ điều hướng

  useEffect(() => {
    if (data?.succeeded !== undefined) {
      setCountdown(10); // Bắt đầu countdown khi API trả về dữ liệu
    }
  }, [data]);

  useEffect(() => {
    if (countdown === undefined || countdown < 0) return;

    const timer = setInterval(() => {
      setCountdown((prev) => (prev !== undefined ? prev - 1 : undefined));
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
      {data?.result === true ? (
        <>
          <a target="_blank">
            <img src={rubySparkles} className="logo react" alt="React logo" />
          </a>
          <p style={styles.successMessage}>Thanh toán thành công</p>
          <button style={styles.button} onClick={handleRedirect}>
            Trở về Viovid
          </button>
        </>
      ) : (
        <>
          <h2 style={styles.errorMessage}>Thanh toán không thành công</h2>
          <button style={styles.button} onClick={handleRedirect}>
            Quay về VioVid
          </button>
        </>
      )}
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

export default MomoResultScreen;
