import { Box, Text, Overlay, LoadingOverlay } from "@mantine/core";

export default function Loading() {
  return <LoadingOverlay visible={true} overlayBlur={2} />;
}
