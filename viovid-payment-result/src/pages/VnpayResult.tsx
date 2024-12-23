import useSWR from "swr";
import { BASE_URL } from "../constants";
import axios, { AxiosResponse } from "axios";
import Loading from "../components/Loading";
import { ApiResult } from "../api_result";
import rubySparkles from "../../../assets/images/ruby_sparkles.png";
import { useEffect, useState } from "react";

interface IPayloadVnpayResult {
  vnp_Amount: string;
  vnp_BankCode: string;
  vnp_BankTranNo: string;
  vnp_CardType: string;
  vnp_OrderInfo: string;
  vnp_PayDate: string;
  vnp_ResponseCode: string;
  vnp_TmnCode: string;
  vnp_TransactionNo: string;
  vnp_TransactionStatus: string;
  vnp_TxnRef: string;
  vnp_SecureHash: string;
}

const fetcher = async (
  url: string,
  payload: IPayloadVnpayResult
): Promise<ApiResult<boolean>> => {
  const response = await axios.post<
    ApiResult<boolean>,
    AxiosResponse<ApiResult<boolean>>,
    IPayloadVnpayResult
  >(url, payload);
  return response.data; // Trả về phần data từ AxiosResponse
};

const handleRedirect = () => {
  window.location.href = "petrichor-viovid://deeplink-to-app";
  setTimeout(() => {
    // Di chuyển về trang chủ
    window.location.href = "http://192.168.1.5:5416/";
  }, 500);
};

const VnpayResultScreen = () => {
  const currentUrl = window.location.href;

  // Parse query params
  const queryParams = new URLSearchParams(currentUrl.split("?")[1]);

  // console.log(queryParams);

  const payload: IPayloadVnpayResult = {
    vnp_Amount: queryParams.get("vnp_Amount") || "",
    vnp_BankCode: queryParams.get("vnp_BankCode") || "",
    vnp_BankTranNo: queryParams.get("vnp_BankTranNo") || "",
    vnp_CardType: queryParams.get("vnp_CardType") || "",
    vnp_OrderInfo: decodeURIComponent(queryParams.get("vnp_OrderInfo") || ""),
    vnp_PayDate: queryParams.get("vnp_PayDate") || "",
    vnp_ResponseCode: queryParams.get("vnp_ResponseCode") || "",
    vnp_TmnCode: queryParams.get("vnp_TmnCode") || "",
    vnp_TransactionNo: queryParams.get("vnp_TransactionNo") || "",
    vnp_TransactionStatus: queryParams.get("vnp_TransactionStatus") || "",
    vnp_TxnRef: queryParams.get("vnp_TxnRef") || "",
    vnp_SecureHash: queryParams.get("vnp_SecureHash") || "",
  };

  // console.log(payload);

  const { data, error, isValidating } = useSWR(
    [`${BASE_URL}/api/Payment/validate-vnpay-result`, payload],
    ([url, payload]: [string, IPayloadVnpayResult]) => fetcher(url, payload),
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
          <h2 style={styles.successMessage}>Thanh toán thành công</h2>
          <button style={styles.button} onClick={handleRedirect}>
            Trở về Viovid
          </button>
        </>
      ) : (
        <>
          <h2 style={styles.errorMessage}>Thanh toán thất bại</h2>
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

export default VnpayResultScreen;
