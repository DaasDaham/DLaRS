import { Box } from "@mui/material";
import React, { useState } from "react";
import styles from "./styles/manager";
import TextField from "@mui/material/TextField";
import Button from "@mui/material/Button";
import MainFunc from "../common/MainFunc";
import InnerForm from "../common/InnerForm";
import { useNavigate } from "react-router-dom";

const Manager = () => {
  const registerLand = [
    "landAddress",
    "city",
    "country",
    "pinCode",
    "payableCurrentOwner",
  ];
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
        <Box sx={styles.mainHeading}>Manager</Box>
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
          <InnerForm
            inputArray={registerLand}
            innerText="Register Land"
            id={id}
          />
        )}
      </Box>
    </>
  );
};
export default Manager;

// const Manager = () => {
//   const [showOutput, setShowOutput] = useState(false);
//   const [isError, setIsError] = useState(false);
//   const inputArray = [
//     "landAddress",
//     "city",
//     "country",
//     "pinCode",
//     "payableCurrentOwner",
//   ];
//   const [formDetails, setFormDetails] = useState({
//     landAddress: "",
//     city: "",
//     country: "",
//     pinCode: "",
//     payableCurrentOwner: "",
//   });

//   // submitHandler
//   const submitHandler = (e) => {
//     setIsError(true);
//     e.preventDefault();
//     setShowOutput(true);
//   };

//   return (
//     <Box sx={styles.mainBox}>
//       <Box sx={styles.mainHeading}>Manager</Box>
//       <TextField
//         sx={styles.input}
//         id="outlined-basic"
//         label="Enter your id"
//         variant="outlined"
//         required
//       />
//       <MainFunc />
//       <Button color="error" style={styles.btn} variant="contained">
//         RegisterLand
//       </Button>
//       <Box sx={styles.formBox}>
//         <form style={styles.form} onSubmit={submitHandler}>
//           {inputArray.map((input, index) => {
//             return (
//               <RootInput
//                 key={index}
//                 value={formDetails[input]}
//                 onChange={(e) =>
//                   setFormDetails((prevState) => {
//                     return {
//                       ...prevState,
//                       [input]: e.target.value,
//                     };
//                   })
//                 }
//                 placeholder={input}
//               />
//             );
//           })}
//           <Button
//             style={styles.submitBtn}
//             color="secondary"
//             type="submit"
//             variant="contained"
//           >
//             Submit
//           </Button>
//         </form>
//       </Box>
//       {showOutput && (
//         <Alert sx={styles.alert} severity={!isError ? "success" : "error"}>
//           {isError ? (
//             <Box>Error Occured</Box>
//           ) : (
//             <Box>
//               Transaction Successful!!!<Box> City : {formDetails.city} </Box>{" "}
//             </Box>
//           )}
//         </Alert>
//       )}
//     </Box>
//   );
// };
