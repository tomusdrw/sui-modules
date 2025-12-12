import { getFullnodeUrl } from "@mysten/sui/client";
import { createNetworkConfig } from "@mysten/dapp-kit";

const { networkConfig, useNetworkVariable, useNetworkVariables } =
  createNetworkConfig({
    devnet: {
      url: getFullnodeUrl("devnet"),
      variables: {
        packageId: "0x[INSTRUCTOR_PROVIDED_PACKAGE_ID]", // TODO: Get package ID from instructor
      },
    },
    testnet: {
      url: getFullnodeUrl("testnet"),
      variables: {
        packageId: "0x45ddc6ae6f8c878ac0f339a9033b7c04fb0a0fab3c315ea74defb929c9345bf0", // TODO: Get package ID from instructor
      },
    },
    mainnet: {
      url: getFullnodeUrl("mainnet"),
      variables: {
        packageId: "0x[INSTRUCTOR_PROVIDED_PACKAGE_ID]", // TODO: Get package ID from instructor
      },
    },
  });

export { useNetworkVariable, useNetworkVariables, networkConfig };
