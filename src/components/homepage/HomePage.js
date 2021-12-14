import React from "react";
import { useNavigate } from "react-router-dom";
import { Box } from "@mui/material";
import Button from "@mui/material/Button";
import styles from "./styles/homepage";
import logo1 from "../../assets/logo.svg";
import logo2 from "../../assets/logo2.png";

const HomePage = () => {
  const navigate = useNavigate();
  return (
    <Box>
      <Box sx={styles.mainHeading}>DLaRs</Box>
      <Box sx={styles.subHeading}>Decentralized Land Registry System</Box>
      <Box sx={styles.btnBox}>
        <Box sx={styles.btnBoxHeading}>Choose Your Role : </Box>
        <Button
          onClick={() => navigate("/manager")}
          variant="contained"
          style={styles.btn}
        >
          Manager
        </Button>
        <Button
          onClick={() => navigate("/seller")}
          color="warning"
          variant="contained"
          style={styles.btn}
        >
          Seller
        </Button>
        <Button
          onClick={() => navigate("/bidder")}
          color="success"
          variant="contained"
          style={styles.btn}
        >
          Bidder
        </Button>
      </Box>
      <Box
        sx={{
          display: "flex",
          width: "100%",
          justifyContent: "center",
          position: "absolute",
          bottom: "50px",
        }}
      >
        <img style={{ height: "60px" }} src={logo1} />
        <img style={{ height: "60px" }} src={logo2} />
      </Box>
      <Box sx={styles.footer}>Made by Aman Aggarwal, Prasham Narayan, Saad Ahmad &copy;</Box>
    </Box>
  );
};

export default HomePage;
