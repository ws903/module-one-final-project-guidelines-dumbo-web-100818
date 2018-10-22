- Stock Ticker Lookup
	- User is able to store a stock they purchased (Create)
		- enter how many stocks
	- User is able to see the current stock price (Read)
	- User is able to calculate profit/lose 
	- Update (Buy More or Price is updating)
	- Sell (Delete)
	- User could have many stocks
	- Users and Stocks are joined by a "Purchase"
		-"Purchase" holds user info and stock info
	- Stock could have many users

	----					--------					-----
	USER  --<   			PURCHASE    		>--  	STOCK  
	----					--------					-----
	- ID					- API 						- NAME (USER INPUT)
	- USERNAME				- QUANTITY					- DATE (DEFAULT: DATETIME)
	- PORTFOLIO				- CARBS	 					- PRICE
 		- MONEY				- STOCK_ID					-
	- *PASSWORD	 			- USER_ID