# CoinSwitchAPI

SDK for interacting with https://coinswitch.co/

## Usage 

        // Create a configuration object by providing your API Key and IP Address
        let configuration = Configuration(
            apiKey: "YOUR-API-KEY",
            userIP: "YOUR-PUBLIC-IP-ADDRESS"
        )
        let api = CoinSwitchAPI(
            configuration: configuration,
            host: "https://api.coinswitch.co",
            version: .v2,
            apiType: .dynamic
        )
        
        // fetch all the coins
        let coins: Observable<CoinsReponse> = api.coins()
        coins
        .subscribe(onNext: { coins in
            print(coins.data.count)
        }, onError: { (error) in
            print(error)
        })
        .disposed(by: bag)
        
        // Gives information about whether a given pair of coins are tradable/exchangable
        let myPair = PairBody(
            depositCoin: "btc",
            destinationCoin: "ltc"
        )
        let pair: Observable<PairResponse> = api.pair(
            body: myPair
        )
        pair
        .subscribe(onNext: { res in
            print(res)
        })
        .disposed(by: bag)
        
        // Gives information about exchange offer for a given pair of coins
        let rateBody = RateBody(
            depositCoin: "btc",
            destinationCoin: "ltc",
            depositCoinAmount: 0.01
        )
        let rate: Observable<RateResponse> = api.rate(body: rateBody)
        rate
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: bag)
        
        // Create a exchange order for a pair of coins
        // Provides the address at which the user will deposit the coin
        let ethAddress = Address(
            address: "0x76F6C1eb7A0dc44A5FE669b698bbD20d9e5c51Ff",
            tag: "xyz123"
        )
        let btcAddress = Address(
            address: "1Q6THRUEKwkdapiFV8K27uFUWNhwTQ2Qxe", tag: "xyb676"
        )

        let order = Order(
            depositCoin: "btc",
            destinationCoin: "eth",
            depositCoinAmount: 2,
            destinationCoinAmount: nil,
            destinationAddress: ethAddress,
            refundAddress: btcAddress,
            callbackUrl: "https://eni1cyocqkvm.x.pipedream.net"
        )
        let submitOrder: Observable<OrderResponse> = api.order(body: order)
        submitOrder
        .subscribe(onNext: { response in
            print(response)
        }, onError: { error in
            print(error)
        })
        .disposed(by: bag)
        
        // Prodives information about the order status
        let orderDetail: Observable<OrderStatusResponse> = api.orderDetail(orderID: "4ffc038e-4a85-45a9-9bd4-d060a58acd4b")
        orderDetail
        .subscribe(onNext: { response in
            print(response.data.validTillDate)
        }, onError: { (error) in
            print(error)
        })
        .disposed(by: bag)
        
        // Gives information about all the orders created for a given account
        let orders: Observable<OrdersReponse> = api.orders(start: 0, count: 5)
        orders
        .subscribe(onNext: { response in
            print(response)
        }, onError: { error in
            print(error)
        })
        .disposed(by: bag)
        
        // Gives exchange rate for a given coins for all the available coins on the platform
        let bulkRate: Observable<BulkRateResponse> = api.bulkRate(body: DepositCoinContainer(depositCoin: "ltc"))
        bulkRate
        .subscribe(onNext: { response in
            print(response)
        })
        .disposed(by: bag)
