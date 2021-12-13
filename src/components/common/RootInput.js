import React from "react";
import TextField from "@mui/material/TextField";

const styles = {
  input: {
    width: "80%",
    mb: "1rem",
  },
};

const RootInput = ({ placeholder, value, onChange }) => {
  return (
    <TextField
      sx={styles.input}
      id="outlined-basic"
      label={placeholder}
      variant="outlined"
      value={value}
      onChange={onChange}
      required
    />
  );
};

export default RootInput;
