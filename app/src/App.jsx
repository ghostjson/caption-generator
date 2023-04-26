import { Box, MantineProvider, Button, Center } from "@mantine/core";
import { CameraPreview } from "@capacitor-community/camera-preview";
import { useEffect, useState } from "react";
import Hud from "./components/Hud";
import Loading from "./components/Loading";

import "./App.css";

export default function App() {
  const [loading, setLoading] = useState(false);

  const play = (id) => {
    const sound = new Audio("http://localhost:5000/audio/" + id);
    sound.play();
  };

  // camera button clicked
  async function cameraButtonClicked() {
    setLoading(true);

    const capture = await CameraPreview.capture({
      quality: 100,
    });

    const requestBody = {
      image: capture.value,
      extension: ".png",
    };
    fetch("http://localhost:5000/api/generate", {
      method: "POST",
      body: JSON.stringify(requestBody),
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => res.json())
      .then((res) => {
        console.log(res);
        play(res.audio_id);
      })
      .catch((err) => {
        console.error(err);
      })
      .finally(() => {
        console.log("finally");
        setLoading(false);
      });
  }

  // start camera preview
  useEffect(() => {
    CameraPreview.start({
      position: "rear",
      parent: "preview",
      toBack: true,
    });
  }, []);

  return (
    <MantineProvider withGlobalStyles withNormalizeCSS>
      <Box bg="red" id="preview"></Box>
      {loading && <Loading />}
      <Hud onClickCameraButton={cameraButtonClicked} />
    </MantineProvider>
  );
}
