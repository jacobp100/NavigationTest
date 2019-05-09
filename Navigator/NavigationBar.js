import React from "react";
import { NavStylesContext, KeyContext } from "./Context";

export default ({ hidden, ...otherProps }) => {
  const setNavStyle = React.useContext(NavStylesContext);
  const key = React.useContext(KeyContext);

  React.useLayoutEffect(
    () => {
      const props =
        hidden != null
          ? { ...otherProps, navigationBarHidden: hidden }
          : otherProps;
      setNavStyle(key, props);
    },
    [setNavStyle, key]
  );

  return null;
};
