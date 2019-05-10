# Navigator Test

:warning: This is a very early experiment and almost everything is broken

An experiment at a new type of React native router. The aims are:

- Native UINavigationController component
- Routes are mounted in the same React route, so can receive React context
- Non-imperative route handing

## Example

```js
export default () => {
  const navigator = {
    pushRoute: route => setRoutes(routes => routes.concat(route)),
    popRoute: route => setRoutes(routes => routes.slice(0, -1))
  };

  const [routes, setRoutes] = React.useState([
    {
      key: "route0",
      component: TestComponent,
      title: "Hello World",
      props: { navigator }
    }
  ]);

  const onRoutesUpdated = e => {
    // When the user navigates back (via back button/gesture)
    const keys = e.nativeEvent.routeKeys;
    setRoutes(routes =>
      keys.map(key => routes.find(route => route.key === key))
    );
  };

  return (
    <Navigator
      style={{ flex: 1 }}
      routes={routes}
      onRoutesUpdated={onRoutesUpdated}
    />
  );
};
```

## API

### Route

#### Options

| Property                 | Description                                                |
| ------------------------ | ---------------------------------------------------------- |
| key **(required)**       | Same as a React key, must be a string                      |
| component **(required)** | What to render                                             |
| title                    | What gets shown in the navigation header                   |
| props                    | What gets passed to the component                          |
| ...navigationStyles      | Route specific navigation styles (overrides global styles) |

### Navigator

#### Props

| Property                       | Description                                                                |
| ------------------------------ | -------------------------------------------------------------------------- |
| routes **(required)**          | Array of routes                                                            |
| onRoutesUpdated **(required)** | Called when the user navigates back. Called with `e.nativeEvent.routeKeys` |
| ...navigationStyles            | Global navigation styles                                                   |

### NavigationBar

Not tested, just a concept. Render this in a route to dynamically change the navigation bar for that route only. Overrides global and route specific styles.

```js
const RouteComponent = () => (
  <>
    <NavigationBar title="Hello World" />
    {someOtherStuff}
  </>
);
```

### Navigation Styles

(Not complete)

| Property            | Description                                                              |
| ------------------- | ------------------------------------------------------------------------ |
| barStyle            | "normal" or "black"                                                      |
| barTintColor        | Literally broken at the moment                                           |
| navigationBarHidden | Hide the navigation bar (also disables the back gesture for some reason) |
