import React from "react";

import "./styles.css";

const Introduction = () => {
  return (
    <code className="introstyle">
      <div>Interactive SVG NFT's running on Avalanche Fuji testnet</div>
      <div>
        Here we have three types of mintable DoGGo's, green, red and blue. You
        can mint them freely.
      </div>
      <div>
        Then with the your NFT's you can breed new DoGGo's with different
        colors.
      </div>
      <div>
        Feel free to test the application and reach your feedback to me. If you
        have any fun ideas we can discuss and build together.
      </div>
      <div>Smart Contract Addresses </div>
      <code>
        <div>DoGGO NFT Smart Contract:</div>
        <div>
          <a
            target="_blank"
            href="https://testnet.snowtrace.io/address/0xfbf56915c81c9faF9998acff68B7a69f9ae0489a#code"
          >
            <div>0xfbf56915...7a69f9ae0489a</div>
          </a>
        </div>
      </code>
      <div>Contact Me: uci.onur@gmail.com</div>
      <div>Onur</div>
    </code>
  );
};

export default Introduction;
