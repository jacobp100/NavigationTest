import React from "react";

export default routes => {
  const [navStyles, setNavStyles] = React.useState({});

  const setNavStyle = React.useCallback(
    (key, styles) => {
      setNavStyles(s => ({ ...s, [key]: styles }));
    },
    [setNavStyles]
  );

  const navKeys = Object.keys(navStyles);

  const hasTooManyNavStyles =
    navKeys.length > routes.length ||
    navKeys.some(key => routes.every(r => r.key !== key));

  if (hasTooManyNavStyles) {
    const reducedNavStyles = routes.reduce((accum, route) => {
      const navStyle = navStyles[route.key];
      if (navStyle != null) accum[route.key] = style;
      return accum;
    }, {});
    setNavStyles(reducedNavStyles);
  }

  return { navStyles, setNavStyle };
};
