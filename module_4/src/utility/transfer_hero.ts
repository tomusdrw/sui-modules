import { Transaction } from "@mysten/sui/transactions";

export const transferHero = (packageId: string, heroId: string, to: string) => {
  const tx = new Transaction();
  
  tx.moveCall({
    package: packageId,
    module: 'hero',
    function: 'transfer_hero',
    arguments: [
      tx.object(heroId),
      tx.pure.address(to),
    ],
  });
  // TODO: Add moveCall to transfer a hero
  // Function: `${packageId}::hero::transfer_hero`  
  // Arguments: heroId (object), to (address)
  // Hints:
  // - Use tx.object() for object IDs
  // - Use tx.pure.address() for addresses
  
  return tx;
};