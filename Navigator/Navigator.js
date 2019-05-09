import React from "react";
import {
  View,
  StyleSheet,
  UIManager,
  NativeModules,
  requireNativeComponent,
  findNodeHandle
} from "react-native";
import { NavStylesContext, KeyContext } from "./Context";
import useNavStyles from "./useNavStyles";

const RCTNavigator = requireNativeComponent("TestNavigator", null);
const RCTNavigatorConfig = UIManager.getViewManagerConfig("TestNavigator");

export default ({ style, routes, onRoutesUpdated, ...globalStyles }) => {
  const { navStyles, setNavStyle } = useNavStyles(routes);
  const navigator = React.useRef(null);

  React.useEffect(
    () => {
      const world = routes.map(({ key, component, props, ...routeStyles }) => ({
        ...globalStyles,
        ...routeStyles,
        ...navStyles[key],
        key
      }));

      UIManager.dispatchViewManagerCommand(
        findNodeHandle(navigator.current),
        RCTNavigatorConfig.Commands.updateWorld,
        [world]
      );
    },
    [routes, navStyles, JSON.stringify(globalStyles)]
  );

  return React.useMemo(
    () => (
      <NavStylesContext.Provider value={setNavStyle}>
        <RCTNavigator
          ref={navigator}
          style={style}
          onRoutesUpdated={onRoutesUpdated}
        >
          {routes.map(({ component: Component, key, props }) => (
            <View key={key} style={StyleSheet.absoluteFill}>
              <KeyContext.Provider value={key}>
                <Component {...props} />
              </KeyContext.Provider>
            </View>
          ))}
        </RCTNavigator>
      </NavStylesContext.Provider>
    ),
    [routes, setNavStyle]
  );
};
