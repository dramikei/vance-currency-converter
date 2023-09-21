# Vance Currency Converter

This is an iOS assignment submitted to [vance](https://vance.tech/). Its a currency converter based on the [Exchange Rate API](https://exchangeratesapi.io/). 

## Features

It Utilizes MVVM Architecture. Custom URLSession wrapper APi Client which itself uses Generics and Decodables to decode the API Responses. 

It also utilises XCConfigs in order to have different API base URLs and API Keys based on the scheme eg. Prod, Dev, Debug etc. However since there actually is no backend other then prod we are only using Prod XCConfig. But it is something that can be used in the future.

APIClient uses a custom `Error` enum called `APIError` which maps to the backend's error status codes which allows the developer to know exactly what went wrong, this could be used in conjuction to some error reporting library like Sentry etc. Allowing the team to know when and where API failed and whether it was Client's or Server's issue.

The UI dynamically changes based on the API's status, whether its being loaded, loaded or has errored out.

Makes use of NumberFormatter to show correctly formatter currency amount with commas.

## Building/Running

Does not require any additional step. Should run directly from xcode as long as the API Key inside `Prod.xcconfig` is valid.
