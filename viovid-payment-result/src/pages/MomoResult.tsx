import useSWR from "swr";
import { BASE_URL } from "../constants";
import axios, { AxiosResponse } from "axios";
import rubySparkles from "../../../assets/images/ruby_sparkles.png";
import { ApiResult } from "../api_result";
import Loading from "../components/Loading";

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
    [`${BASE_URL}/api/Payment/momo-callback`, payload],
    ([url, payload]: [string, IMomoCallBackData]) => fetcher(url, payload),
    {
      revalidateOnFocus: false, // Không gọi lại API khi tab được focus
      revalidateOnReconnect: false, // Không gọi lại API khi mạng được khôi phục
    }
  );

  if (error) return <h2 style={styles.errorMessage}>Có lỗi xảy ra</h2>;
  if (isValidating) return <Loading />;

  if (data?.succeeded !== undefined) {
    setTimeout(() => {
      window.location.href = "http://192.168.1.8:5416/";
    }, 10000);
  }

  return (
    <div style={styles.container}>
      {data?.result === true ? (
        <>
          <a target="_blank">
            <img src={rubySparkles} className="logo react" alt="React logo" />
          </a>
          <p style={styles.successMessage}>Thanh toán thành công</p>
          <button
            style={styles.button}
            onClick={() => {
              window.location.href = "petrichor-viovid://deeplink-to-app";
            }}
          >
            Trở về Viovid
          </button>
        </>
      ) : (
        <>
          <h2 style={styles.errorMessage}>Thanh toán không thành công</h2>
          <button
            style={styles.button}
            onClick={() => {
              window.location.href =
                "petrichor-viovid://deeplink-to-app/register-plan";
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
