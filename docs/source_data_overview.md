# Source Data Overview

## Revolut Transactions

File Format: CSV  
Encoding: UTF-8  
Currency: GBP  

Columns:

- Type
- Product
- Started Date
- Completed Date
- Description
- Amount
- Fee
- Currency
- State
- Balance

Notes:
- Amount is signed (negative = debit, positive = credit)
- All timestamps are local UK time
- Currency currently only GBP
- State should be COMPLETED for valid transactions

Future sources:
- HSBC (PDF extract)
- Monzo (CSV export)
