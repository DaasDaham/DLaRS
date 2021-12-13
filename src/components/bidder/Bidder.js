import { Box } from "@mui/material";
import React, { useState } from "react";
import styles from "../manager/styles/manager";
import TextField from "@mui/material/TextField";
import Button from "@mui/material/Button";
import MainFunc from "../common/MainFunc";
import InnerForm from "../common/InnerForm";
import { useNavigate } from "react-router-dom";

const Bidder = () => {
  const placeBid = ["landId"];
  const terminateAuction = ["landId"];

  const [id, setId] = useState("");
  const [viewFunc, setViewFunc] = useState(false);
  const navigate = useNavigate();

  return (
    <>
      <Button
        onClick={() => {
          navigate("/");
        }}
      >
        Back
      </Button>
      <Box sx={styles.mainBox}>
        <Box sx={styles.mainHeading}>Bidder</Box>
        <TextField
          sx={styles.input}
          id="outlined-basic"
          label="Enter your id"
          variant="outlined"
          value={id}
          onChange={(e) => setId(e.target.value)}
          required
        />
        <Button onClick={() => setViewFunc(true)}>View Functionality</Button>
        {viewFunc && <MainFunc id={id} />}
        {viewFunc && (
          <>
            <InnerForm inputArray={placeBid} innerText="Place Bid" id={id} />
            <InnerForm
              inputArray={terminateAuction}
              innerText="Terminate Auction"
              id={id}
            />
          </>
        )}
      </Box>
    </>
  );
};
export default Bidder;
