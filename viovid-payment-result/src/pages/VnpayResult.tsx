import useSWR from "swr";
import { BASE_URL } from "../constants";
import axios, { AxiosResponse } from "axios";
import Loading from "../components/Loading";

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

interface ApiResult<T> {
  succeeded: boolean;
  result: T;
  errors: [];
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

const VnpayResultScreen = () => {
  const currentUrl = window.location.href;

  // Parse query params
  const queryParams = new URLSearchParams(currentUrl.split("?")[1]);

  console.log(queryParams);

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

  console.log(payload);

  const { data, error, isValidating } = useSWR(
    [`${BASE_URL}/api/Payment/validate-vnpay-result`, payload],
    ([url, payload]: [string, IPayloadVnpayResult]) => fetcher(url, payload),
    {
      revalidateOnFocus: false, // Không gọi lại API khi tab được focus
      revalidateOnReconnect: false, // Không gọi lại API khi mạng được khôi phục
    }
  );

  if (error) return <h2 style={styles.errorMessage}>Có lỗi xảy ra</h2>;
  if (isValidating) return <Loading />;

  console.log(data);
  console.log("data.result = ", data?.result);

  return (
    <div style={styles.container}>
      {data?.result === true ? (
        <>
          <h2 style={styles.successMessage}>Thanh toán thành công</h2>
          <button
            style={styles.button}
            onClick={() => {
              window.location.href = "petrichor-viovid://deeplink-to-app/";
            }}
          >
            Trở về Viovid
          </button>
        </>
      ) : (
        <>
          <h2 style={styles.errorMessage}>Thanh toán thất bại</h2>
          <button
            style={styles.button}
            onClick={() => {
              window.location.href = "petrichor-viovid://deeplink-to-app/";
            }}
          >
            Quay về VioVid
          </button>
        </>
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
    color: "#000", // Green color to indicate success
    marginBottom: "20px",
  },
  errorMessage: {
    fontSize: "24px",
    fontWeight: "bold",
    color: "#f00", // Green color to indicate success
    marginBottom: "20px",
  },
};

export default VnpayResultScreen;
