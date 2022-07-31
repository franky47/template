import { Alert } from "@dataesr/react-dsfr";
import type { NextPage } from "next";
import React from "react";

const PageB: NextPage = () => {
  return (
    <div className="fr-container fr-my-6w">
      <h1>Lien B</h1>
      <Alert title="Cette page doit être mise à jour. " type="info" />
    </div>
  );
};

export default PageB;
