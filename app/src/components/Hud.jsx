import { Box, Button, Center, Flex } from "@mantine/core";
import { IconCameraSelfie, IconSettings } from "@tabler/icons-react";

export default function Hud({ onClickCameraButton }) {
  return (
    <Box w="100vw" h="100vh" pos="absolute" top={0}>
      <Flex pos="absolute" w="100vw" bg="blue" justify="flex-end">
        <Box mt={5} mr={10}>
          <IconSettings color="white" size={40} />
        </Box>
      </Flex>
      <Box pos="absolute" bottom={50} w="100vw">
        <Center>
          <Button radius={100} w={60} h={60} p={0}>
            <IconCameraSelfie size={40} onClick={onClickCameraButton} />
          </Button>
        </Center>
      </Box>
    </Box>
  );
}
