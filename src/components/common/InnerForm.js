import React, { useState } from "react";
import { Box, Button } from "@mui/material";
import RootInput from "./RootInput";
import styles from "./styles/innerForm";
import Alert from "@mui/material/Alert";

const InnerForm = ({ inputArray, innerText, id }) => {
  console.log("this is passed id ", id);
  let initObj = { id };
  const [showForm, setShowForm] = useState(false);

  inputArray.map((input) => {
    initObj = { ...initObj, [input]: "" };
  });

  const [formDetails, setFormDetails] = useState(initObj);
  const [showOutput, setShowOutput] = useState(false);
  const [isError, setIsError] = useState(false);
  const [outputString, setOuptutString] = useState("");

  console.log("this is form details", formDetails);

  // submitHandler
  const submitHandler = (e) => {
    setIsError(false);
    e.preventDefault();
    setShowOutput(true);
    setOuptutString([<Box>id : {id} </Box>, <Box>Hello world</Box>]);
  };

  // clickHandler
  const clickHandler = () => {
    setShowForm((prev) => !prev);
  };

  return (
    <Box
      sx={{
        width: "100%",
      }}
    >
      <Button
        onClick={clickHandler}
        color="error"
        style={styles.btn}
        variant="contained"
      >
        {innerText}
      </Button>
      {showForm && (
        <Box sx={styles.formBox}>
          <form style={styles.form} onSubmit={submitHandler}>
            {inputArray.map((input, index) => {
              return (
                <RootInput
                  key={index}
                  value={formDetails[input]}
                  onChange={(e) =>
                    setFormDetails((prevState) => {
                      return {
                        ...prevState,
                        [input]: e.target.value,
                      };
                    })
                  }
                  placeholder={input}
                />
              );
            })}
            <Button
              style={styles.submitBtn}
              color="secondary"
              type="submit"
              variant="contained"
            >
              Submit
            </Button>
          </form>
        </Box>
      )}
      {showOutput && (
        <Alert
          onClose={() => setShowOutput(false)}
          sx={styles.alert}
          severity={!isError ? "success" : "error"}
        >
          {isError ? (
            <Box>Error Occured</Box>
          ) : (
            <Box>`Transaction Successful!!! ${outputString}`</Box>
          )}
        </Alert>
      )}
    </Box>
  );
};

export default InnerForm;
