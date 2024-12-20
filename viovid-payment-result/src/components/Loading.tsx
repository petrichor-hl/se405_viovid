import "./Loading.css"; // Đảm bảo đường dẫn chính xác đến file CSS

const Loading = () => {
  return (
    <>
      <p className="loadingTxt">Đang xác nhận ... </p>
      <div className="loader"></div>
    </>
  );
};

export default Loading;
