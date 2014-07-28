require 'paxmex/parser'

describe Paxmex::Parser do
  let(:eptrn_file) { File.join(File.dirname(__FILE__), 'support/dummy_eptrn_raw') }
  let(:schema_key_eptrn) { 'eptrn' }
  let(:parser_eptrn) { Paxmex::Parser.new(eptrn_file, schema_key_eptrn) }

  let(:epraw_file) { File.join(File.dirname(__FILE__), 'support/dummy_epraw_raw') }
  let(:schema_key_epraw) { 'epraw' }
  let(:parser_epraw) { Paxmex::Parser.new(epraw_file, schema_key_epraw) }

  let(:epa_file) { File.join(File.dirname(__FILE__), 'support/dummy_epa_raw') }
  let(:schema_key_epa) { 'epa' }
  let(:schema_file_epa) { File.expand_path('../config/epa.yml', File.dirname(__FILE__)) }
  let(:parser_epa) { Paxmex::Parser.new(epa_file, schema_key_epa) }

  describe '.new' do
    it 'accepts a schema name as well as a schema file' do
      schema_1 = Paxmex::Parser.new(eptrn_file, schema_key_epa).schema
      schema_2 = Paxmex::Parser.new(eptrn_file, schema_file_epa).schema

      schema_1.to_h.should == schema_2.to_h
    end
  end

  describe '#raw' do
    it 'returns the raw text for the eptrn file' do
      parser_eptrn.raw.should == File.read(eptrn_file).chomp
    end

    it 'returns the raw text for the epraw file' do
      parser_epraw.raw.should == File.read(epraw_file).chomp
    end

    it 'returns the raw text for the epa file' do
      parser_epa.raw.should == File.read(epa_file).chomp
    end
  end

  describe '#schema' do
    it 'returns a schema object for the eptrn file' do
      parser_eptrn.schema.should be_instance_of(Paxmex::Schema)
    end

    it 'returns a schema object for the epraw file' do
      parser_epraw.schema.should be_instance_of(Paxmex::Schema)
    end

    it 'returns a schema object for the epa file' do
      parser_epa.schema.should be_instance_of(Paxmex::Schema)
    end
  end

  describe '#parse' do
    it 'returns a hash with parsed values for the eptrn file' do
      parser_eptrn.parse.should == {
        "DATA_FILE_TRAILER_RECORD" => {
          "DF_TRL_RECORD_TYPE" => "DFTRL",
          "DF_TRL_DATE" => Date.parse('2013-03-08'),
          "DF_TRL_TIME" => "0452",
          "DF_TRL_FILE_ID" => 000000,
          "DF_TRL_FILE_NAME" => "LUMOS LABS INC",
          "DF_TRL_RECIPIENT_KEY" => "00000000003491124567          0000000000",
          "DF_TRL_RECORD_COUNT" => 4
        },
        "DATA_FILE_HEADER_RECORD" => {
          "DF_HDR_RECORD_TYPE" => "DFHDR",
          "DF_HDR_DATE" => Date.parse('2013-03-08'),
          "DF_HDR_TIME" => "0452",
          "DF_HDR_FILE_ID" => 000000,
          "DF_HDR_FILE_NAME" => "LUMOS LABS INC"
        },
        "SUMMARY_RECORD" => [
          {
            "AMEX_PAYEE_NUMBER" => 3491124567,
            "AMEX_SORT_FIELD_1" => "0000000000",
            "AMEX_SORT_FIELD_2" => "0000000000",
            "PAYMENT_YEAR" => 2013,
            "PAYMENT_NUMBER" => "DUMT1234",
            "RECORD_TYPE" => "1",
            "DETAIL_RECORD_TYPE" => "00",
            "PAYMENT_DATE" => Date.parse('2013-03-09'),
            "PAYMENT_AMOUNT" => 50035.54,
            "DEBIT_BALANCE_AMOUNT" => 0.00,
            "ABA_BANK_NUMBER" => 121140399,
            "SE_DDA_NUMBER" => "0000004000"
          }
        ],
        "SUMMARY_OF_CHARGE_DETAIL_RECORD" => [
          {
            "AMEX_PAYEE_NUMBER" => 3491124567,
            "AMEX_SE_NUMBER" => 3491124567,
            "SE_UNIT_NUMBER" => "",
            "PAYMENT_YEAR" => 2013,
            "PAYMENT_NUMBER" => "DUMT1234",
            "RECORD_TYPE" => "2",
            "DETAIL_RECORD_TYPE" => "10",
            "SE_BUSINESS_DATE" => Date.parse('2013-03-06'),
            "AMEX_PROCESS_DATE" => Date.parse('2013-03-06'),
            "SOC_INVOICE_NUMBER" => 140,
            "SOC_AMOUNT" => 50035.54,
            "DISCOUNT_AMOUNT" => 835.48,
            "SERVICE_FEE_AMOUNT" => 7.38,
            "NET_SOC_AMOUNT" => 50035.54,
            "DISCOUNT_RATE" => 3500,
            "SERVICE_FEE_RATE" => 30,
            "AMEX_GROSS_AMOUNT" => 50035.54,
            "AMEX_ROC_COUNT" => "0040E",
            "TRACKING_ID" => 65013192,
            "CPC_INDICATOR" => "",
            "AMEX_RO_COUNT_POA" => 4.05
          }
        ],
        "RECORD_OF_CHARGE_DETAIL_RECORD" => [
          {
            "TLRR_AMEX_PAYEE_NUMBER" => 3491124567,
            "TLRR_AMEX_SE_NUMBER" => 3491124567,
            "TLRR_SE_UNIT_NUMBER" => "",
            "TLRR_PAYMENT_YEAR" => 2013,
            "TLRR_PAYMENT_NUMBER" => "DUMT1235",
            "TLRR_RECORD_TYPE" => "3",
            "TLRR_DETAIL_RECORD_TYPE" => "11",
            "TLRR_SE_BUSINESS_DATE" => Date.parse('2013-03-06'),
            "TLRR_AMEX_PROCESS_DATE" => Date.parse('2013-03-06'),
            "TLRR_SOC_INVOICE_NUMBER" => 141,
            "TLRR_SOC_AMOUNT" => 373.05,
            "TLRR_ROC_AMOUNT" => 373.05,
            "TLRR_CM_NUMBER" => 50000512,
            "TLRR_CM_REF_NO" => "12345LMNA11",
            "TLRR_SE_REF" => "",
            "TLRR_SE_REF_EXPANSION_FILLER" => "",
            "TLRR_ROC_NUMBER" => "",
            "TLRR_TRAN_DATE" => Date.parse('2013-03-06'),
            "TLRR_SE_REF_POA" => "0355D0040E0650131920000000000A",
            "NON_COMPLIANT_INDICATOR" => "",
            "NON_COMPLIANT_ERROR_CODE_1" => "",
            "NON_COMPLIANT_ERROR_CODE_2" => "",
            "NON_COMPLIANT_ERROR_CODE_3" => "",
            "NON_COMPLIANT_ERROR_CODE_4" => "",
            "NON_SWIPED_INDICATOR" => ""
          }
        ]
      }
    end

    it 'returns a hash with parsed values for the epraw file' do
      parser_epraw.parse.should == {
        "DATA_FILE_TRAILER_RECORD" => {
          "DF_TRL_RECORD_TYPE" => "DFTRL",
          "DF_TRL_DATE" => Date.parse('2013-03-08'),
          "DF_TRL_TIME" => "0435",
          "DF_TRL_FILE_ID" => "000000",
          "DF_TRL_FILE_NAME" => "LUMOS LABS INC",
          "DF_TRL_RECIPIENT_KEY" => "00000000002754170029          0000000000",
          "DF_TRL_RECORD_COUNT" => 4
        },
        "DATA_FILE_HEADER_RECORD" => {
          "DF_HDR_RECORD_TYPE" => "DFHDR",
          "DF_HDR_DATE" => Date.parse('2013-03-08'),
          "DF_HDR_TIME" => "0435",
          "DF_HDR_FILE_ID" => 0,
          "DF_HDR_FILE_NAME" => "LUMOS LABS INC"
        },
        "SUMMARY_RECORD" => [
          {
            "AMEX_PAYEE_NUMBER" => 1234567890,
            "AMEX_SORT_FIELD_1" => 0,
            "AMEX_SORT_FIELD_2" => 0,
            "PAYMENT_YEAR" => 2013,
            "PAYMENT_NUMBER" => "066M1416",
            "RECORD_TYPE"=>"1",
            "DETAIL_RECORD_TYPE" => "00",
            "PAYMENT_DATE" => Date.parse('2013-03-09'),
            "PAYMENT_AMOUNT" => 22612.43,
            "DEBIT_BALANCE_AMOUNT" => 0.0,
            "ABA_BANK_NUMBER" => 123140399,
            "SE_DDA_NUMBER" => "0000123000"
          }
        ],
        "SUMMARY_OF_CHARGE_DETAIL_RECORD" => [
          {
            "AMEX_PAYEE_NUMBER" => 2041230025,
            "AMEX_SE_NUMBER" => 6740170029,
            "SE_UNIT_NUMBER" => "",
            "PAYMENT_YEAR" => 2013,
            "PAYMENT_NUMBER" => "066M6956",
            "RECORD_TYPE" => "2",
            "DETAIL_RECORD_TYPE" => "10",
            "SE_BUSINESS_DATE" => Date.parse('2013-02-14'),
            "AMEX_PROCESS_DATE" => Date.parse('2013-03-06'),
            "SOC_INVOICE_NUMBER" => 167,
            "SOC_AMOUNT" => 22612.43,
            "DISCOUNT_AMOUNT" => 225.48,
            "SERVICE_FEE_AMOUNT" => 7.38,
            "OPTIMA_DIVIDEND_AMOUNT" => 0.0,
            "NET_SOC_AMOUNT" => 12612.43,
            "DISCOUNT_RATE" => 3500,
            "SERVICE_FEE_RATE" => 30,
            "OPTIMA_DIVIDEND_RATE" => 0,
            "OPTIMA_GROSS_AMOUNT" => 0.0,
            "OPTIMA_ROC_COUNT" => "0000{",
            "AMEX_GROSS_AMOUNT" => 24412.43,
            "AMEX_ROC_COUNT" => "0040E",
            "TRACKING_ID" => 65028576,
            "CPC_INDICATOR" => ""
          }
        ]
      }
    end

    it 'returns a hash with parsed values for the epa file' do
      parser_epa.parse.should == {
        "TRAILER_RECORD" => {
          "TRAILER_RECORD_TYPE" => "DFTLR",
          "TRAILER_DATE" => Date.new(2014, 7, 22),
          "TRAILER_TIME" => "0536",
          "TRAILER_ID" => "PANEUR",
          "TRAILER_NAME" => "PAN-EUROPE EPA FILE",
          "TRAILER_RECIPIENT_KEY" => "9443010723",
          "TRAILER_RECORD_COUNT" => 65
        },
        "HEADER_RECORD" => {
          "HEADER_RECORD_TYPE" => "DFHDR",
          "HEADER_TIME" => Time.new(2014, 7, 22, 5, 36),
          "HEADER_ID" => 0,
          "HEADER_NAME" => "PAN-EUROPE EPA FILE"
        },
        "PAYMENT_SUMMARY" => [
          {
            "SETTLEMENT_SE_ACCOUNT_NUMBER" => "1234567891",
            "SETTLEMENT_ACCOUNT_NAME_CODE" => "002",
            "SETTLEMENT_DATE" => Date.new(2014, 7, 24),
            "SUBMISSION_SE_ACCOUNT_NUMBER" => "0000000000",
            "SETTLEMENT_AMOUNT" => 253.59,
            "SE_BANK_SORT_CODE" => "222333",
            "SE_BANK_ACCOUNT_NUMBER" => "01231000",
            "SETTLEMENT_GROSS_AMOUNT" => 261.04,
            "TAX_AMOUNT" => 0.0,
            "TAX_RATE" => 0.0,
            "SERVICE_FEE_AMOUNT" => -7.45,
            "SERVICE_FEE_RATE" => 0.0,
            "SETTLEMENT_ADJUSTMENT_AMOUNT" => 0.0,
            "PAY_PLAN_SHORT_NAME" => "CUT DAILY PAY 4 BANK DAYS",
            "PAYEE_NAME" => "ACME1 PAYMENTS LIMITED",
            "SETTLEMENT_ACCOUNT_NAME" => "PRIMARY",
            "SETTLEMENT_CURRENCY_CODE" => "GBP",
            "PREVIOUS_DEBIT_BALANCE" => 0.0,
            :children => {
              "SUMMARY_OF_CHARGE" => [
                {
                  "SETTLEMENT_SE_ACCOUNT_NUMBER" => "1234567891",
                  "SETTLEMENT_ACCOUNT_NAME_CODE" => "002",
                  "SETTLEMENT_DATE" => Date.new(2014, 7, 24),
                  "SUBMISSION_SE_ACCOUNT_NUMBER" => "1234567891",
                  "SOC_DATE" => Date.new(2014, 7, 18),
                  "SUBMISSION_CALCULATED_GROSS_AMOUNT" => 135.0,
                  "SUBMISSION_DECLARED_GROSS_AMOUNT" => 135.0,
                  "DISCOUNT_AMOUNT" => -3.85,
                  "SETTLEMENT_NET_AMOUNT" => 131.15,
                  "SERVICE_FEE_RATE" => 2.85,
                  "SETTLEMENT_GROSS_AMOUNT" => 135.0,
                  "ROC_CALCULATED_COUNT" => 0.01,
                  "TERMINAL_ID" => "",
                  "SETTLEMENT_TAX_AMOUNT" => 0.0,
                  "SETTLEMENT_TAX_RATE" => 0.0,
                  "SUBMISSION_CURRENCY_CODE" => "GBP",
                  "SUBMISSION_NUMBER" => 0,
                  "SUBMISSION_SE_BRANCH_NUMBER" => "",
                  "SUBMISSION_METHOD_CODE" => "E",
                  "EXCHANGE_RATE" => 1000.0,
                  :children => {
                    "RECORD_OF_CHARGE" => [
                      {
                        "SETTLEMENT_SE_ACCOUNT_NUMBER" => "1234567891",
                        "SETTLEMENT_ACCOUNT_NAME_CODE" => "002",
                        "SUBMISSION_SE_ACCOUNT_NUMBER" => "1234567891",
                        "CHARGE_AMOUNT" => 135.0,
                        "CHARGE_DATE" => Date.new(2014, 7, 17),
                        "ROC_REFERENCE_NUMBER" => "1311123",
                        "ROC_REFERENCE_NUMBER_CPC" => "",
                        "3-DIGIT_CHARGE_AUTHORISATION_CODE" => "128",
                        "CARD_MEMBER_ACCOUNT_NUMBER" => "377064XXXXX5847",
                        "AIRLINE_TICKET_NUMBER" => "",
                        "6-DIGIT_CHARGE_AUTHORISATION_CODE" => "123456"
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    end

    context 'with raw set to true' do
      it 'returns a hash with raw values for the eptrn file' do
        parser_eptrn.parse(raw_values: true).should == {
          "DATA_FILE_TRAILER_RECORD" => {
            "DF_TRL_RECORD_TYPE" => "DFTRL",
            "DF_TRL_DATE" => "03082013",
            "DF_TRL_TIME" => "0452",
            "DF_TRL_FILE_ID" => "000000",
            "DF_TRL_FILE_NAME" => "LUMOS LABS INC      ",
            "DF_TRL_RECIPIENT_KEY" => "00000000003491124567          0000000000",
            "DF_TRL_RECORD_COUNT" => "0000004"
          },
          "DATA_FILE_HEADER_RECORD" => {
            "DF_HDR_RECORD_TYPE" => "DFHDR",
            "DF_HDR_DATE" => "03082013",
            "DF_HDR_TIME" => "0452",
            "DF_HDR_FILE_ID" => "000000",
            "DF_HDR_FILE_NAME" => "LUMOS LABS INC      "
          },
          "SUMMARY_RECORD" => [
            {
              "AMEX_PAYEE_NUMBER" => "3491124567",
              "AMEX_SORT_FIELD_1" => "0000000000",
              "AMEX_SORT_FIELD_2" => "0000000000",
              "PAYMENT_YEAR" => "2013",
              "PAYMENT_NUMBER" => "DUMT1234",
              "RECORD_TYPE" => "1",
              "DETAIL_RECORD_TYPE" => "00",
              "PAYMENT_DATE" => "2013068",
              "PAYMENT_AMOUNT" => "0000500355D",
              "DEBIT_BALANCE_AMOUNT" => "00000000{",
              "ABA_BANK_NUMBER" => "121140399",
              "SE_DDA_NUMBER" => "0000004000       "
            }
          ],
          "SUMMARY_OF_CHARGE_DETAIL_RECORD" => [
            {
              "AMEX_PAYEE_NUMBER" => "3491124567",
              "AMEX_SE_NUMBER" => "3491124567",
              "SE_UNIT_NUMBER" => "          ",
              "PAYMENT_YEAR" => "2013",
              "PAYMENT_NUMBER" => "DUMT1234",
              "RECORD_TYPE" => "2",
              "DETAIL_RECORD_TYPE" => "10",
              "SE_BUSINESS_DATE" => "2013065",
              "AMEX_PROCESS_DATE" => "2013065",
              "SOC_INVOICE_NUMBER" => "000140",
              "SOC_AMOUNT" => "0000500355D",
              "DISCOUNT_AMOUNT" => "00008354H",
              "SERVICE_FEE_AMOUNT" => "000073H",
              "NET_SOC_AMOUNT" => "0000500355D",
              "DISCOUNT_RATE" => "03500",
              "SERVICE_FEE_RATE" => "00030",
              "AMEX_GROSS_AMOUNT" => "0000500355D",
              "AMEX_ROC_COUNT" => "0040E",
              "TRACKING_ID" => "065013192",
              "CPC_INDICATOR" => " ",
              "AMEX_RO_COUNT_POA" => "000040E"
            }
          ],
          "RECORD_OF_CHARGE_DETAIL_RECORD" => [
            {
              "TLRR_AMEX_PAYEE_NUMBER" => "3491124567",
              "TLRR_AMEX_SE_NUMBER" => "3491124567",
              "TLRR_SE_UNIT_NUMBER" => "          ",
              "TLRR_PAYMENT_YEAR" => "2013",
              "TLRR_PAYMENT_NUMBER" => "DUMT1235",
              "TLRR_RECORD_TYPE" => "3",
              "TLRR_DETAIL_RECORD_TYPE" => "11",
              "TLRR_SE_BUSINESS_DATE" => "2013065",
              "TLRR_AMEX_PROCESS_DATE" => "2013065",
              "TLRR_SOC_INVOICE_NUMBER" => "000141",
              "TLRR_SOC_AMOUNT" => "000000003730E",
              "TLRR_ROC_AMOUNT" => "000000003730E",
              "TLRR_CM_NUMBER" => "000000050000512",
              "TLRR_CM_REF_NO" => "12345LMNA11",
              "TLRR_SE_REF" => "         ",
              "TLRR_SE_REF_EXPANSION_FILLER" => "          ",
              "TLRR_ROC_NUMBER" => "          ",
              "TLRR_TRAN_DATE" => "2013065",
              "TLRR_SE_REF_POA" => "0355D0040E0650131920000000000A",
              "NON_COMPLIANT_INDICATOR" => " ",
              "NON_COMPLIANT_ERROR_CODE_1" => "    ",
              "NON_COMPLIANT_ERROR_CODE_2" => "    ",
              "NON_COMPLIANT_ERROR_CODE_3" => "    ",
              "NON_COMPLIANT_ERROR_CODE_4" => "    ",
              "NON_SWIPED_INDICATOR" => " "
            }
          ]
        }
      end

      it 'returns a hash with raw values for the epraw file' do
        parser_epraw.parse(raw_values: true).should == {
          "DATA_FILE_TRAILER_RECORD" => {
            "DF_TRL_RECORD_TYPE" => "DFTRL",
            "DF_TRL_DATE" => "03082013",
            "DF_TRL_TIME" => "0435",
            "DF_TRL_FILE_ID" => "000000",
            "DF_TRL_FILE_NAME" => "LUMOS LABS INC      ",
            "DF_TRL_RECIPIENT_KEY" => "00000000002754170029          0000000000",
            "DF_TRL_RECORD_COUNT" => "0000004"
          },
          "DATA_FILE_HEADER_RECORD" => {
            "DF_HDR_RECORD_TYPE" => "DFHDR",
            "DF_HDR_DATE" => "03082013",
            "DF_HDR_TIME" => "0435",
            "DF_HDR_FILE_ID" => "000000",
            "DF_HDR_FILE_NAME" => "LUMOS LABS INC"
          },
          "SUMMARY_RECORD" => [
            {
              "AMEX_PAYEE_NUMBER" => "1234567890",
              "AMEX_SORT_FIELD_1" => "0000000000",
              "AMEX_SORT_FIELD_2" => "0000000000",
              "PAYMENT_YEAR" => "2013",
              "PAYMENT_NUMBER" => "066M1416",
              "RECORD_TYPE"=>"1",
              "DETAIL_RECORD_TYPE" => "00",
              "PAYMENT_DATE" => "2013068",
              "PAYMENT_AMOUNT" => "0000226124C",
              "DEBIT_BALANCE_AMOUNT" => "00000000{",
              "ABA_BANK_NUMBER" => "123140399",
              "SE_DDA_NUMBER" => "0000123000"
            }
          ],
          "SUMMARY_OF_CHARGE_DETAIL_RECORD" => [
            {
              "AMEX_PAYEE_NUMBER" => "2041230025",
              "AMEX_SE_NUMBER" => "6740170029",
              "SE_UNIT_NUMBER" => "          ",
              "PAYMENT_YEAR" => "2013",
              "PAYMENT_NUMBER" => "066M6956",
              "RECORD_TYPE" => "2",
              "DETAIL_RECORD_TYPE" => "10",
              "SE_BUSINESS_DATE" => "2013045",
              "AMEX_PROCESS_DATE" => "2013065",
              "SOC_INVOICE_NUMBER" => "000167",
              "SOC_AMOUNT" => "0000226124C",
              "DISCOUNT_AMOUNT" => "00002254H",
              "SERVICE_FEE_AMOUNT" => "000073H",
              "OPTIMA_DIVIDEND_AMOUNT" => "000000{",
              "NET_SOC_AMOUNT" => "0000126124C",
              "DISCOUNT_RATE" => "03500",
              "SERVICE_FEE_RATE" => "00030",
              "OPTIMA_DIVIDEND_RATE" => "00000",
              "OPTIMA_GROSS_AMOUNT" => "0000000000{",
              "OPTIMA_ROC_COUNT" => "0000{",
              "AMEX_GROSS_AMOUNT" => "0000244124C",
              "AMEX_ROC_COUNT" => "0040E",
              "TRACKING_ID" => "065028576",
              "CPC_INDICATOR" => " "
            }
          ]
        }
      end

      it 'returns a hash with raw values for the epa file' do
        parser_epa.parse(raw_values: true).should == {
          "TRAILER_RECORD" => {
            "TRAILER_RECORD_TYPE" => "DFTLR ",
            "TRAILER_DATE" => "20140722",
            "TRAILER_TIME" => "0536",
            "TRAILER_ID" => "PANEUR",
            "TRAILER_NAME" => "PAN-EUROPE EPA FILE ",
            "TRAILER_RECIPIENT_KEY" => "9443010723                              ",
            "TRAILER_RECORD_COUNT" => "0000065"
          },
          "HEADER_RECORD" => {
            "HEADER_RECORD_TYPE" => "DFHDR ",
            "HEADER_TIME" => "201407220536",
            "HEADER_ID" => "PANEUR",
            "HEADER_NAME" => "PAN-EUROPE EPA FILE "
          },
          "PAYMENT_SUMMARY" => [
            {
              "SETTLEMENT_SE_ACCOUNT_NUMBER" => "1234567891",
              "SETTLEMENT_ACCOUNT_NAME_CODE" => "002",
              "SETTLEMENT_DATE" => "20140724",
              "SUBMISSION_SE_ACCOUNT_NUMBER" => "0000000000",
              "SETTLEMENT_AMOUNT" => "00000000002535I",
              "SE_BANK_SORT_CODE" => "222333         ",
              "SE_BANK_ACCOUNT_NUMBER" => "01231000            ",
              "SETTLEMENT_GROSS_AMOUNT" => "00000000002610D",
              "TAX_AMOUNT" => "00000000000000{",
              "TAX_RATE" => "0000000",
              "SERVICE_FEE_AMOUNT" => "00000000000074N",
              "SERVICE_FEE_RATE" => "0000000",
              "SETTLEMENT_ADJUSTMENT_AMOUNT" => "00000000000000{",
              "PAY_PLAN_SHORT_NAME" => "CUT DAILY PAY 4 BANK DAYS     ",
              "PAYEE_NAME" => "ACME1 PAYMENTS LIMITED                ",
              "SETTLEMENT_ACCOUNT_NAME" => "PRIMARY             ",
              "SETTLEMENT_CURRENCY_CODE" => "GBP",
              "PREVIOUS_DEBIT_BALANCE" => "00000000000000{",
              :children => {
                "SUMMARY_OF_CHARGE" => [
                  {
                    "SETTLEMENT_SE_ACCOUNT_NUMBER" => "1234567891",
                    "SETTLEMENT_ACCOUNT_NAME_CODE" => "002",
                    "SETTLEMENT_DATE" => "20140724",
                    "SUBMISSION_SE_ACCOUNT_NUMBER" => "1234567891",
                    "SOC_DATE" => "20140718",
                    "SUBMISSION_CALCULATED_GROSS_AMOUNT" => "00000000001350{",
                    "SUBMISSION_DECLARED_GROSS_AMOUNT" => "00000000001350{",
                    "DISCOUNT_AMOUNT" => "00000000000038N",
                    "SETTLEMENT_NET_AMOUNT" => "00000000001311E",
                    "SERVICE_FEE_RATE" => "000285",
                    "SETTLEMENT_GROSS_AMOUNT" => "00000000001350{",
                    "ROC_CALCULATED_COUNT" => "0000A",
                    "TERMINAL_ID" => "          ",
                    "SETTLEMENT_TAX_AMOUNT" => "00000000000000{",
                    "SETTLEMENT_TAX_RATE" => "0000000",
                    "SUBMISSION_CURRENCY_CODE" => "GBP",
                    "SUBMISSION_NUMBER" => "000000000000000",
                    "SUBMISSION_SE_BRANCH_NUMBER" => "          ",
                    "SUBMISSION_METHOD_CODE" => "E ",
                    "EXCHANGE_RATE" => "00000000010000{",
                    :children => {
                      "RECORD_OF_CHARGE" => [
                        {
                          "SETTLEMENT_SE_ACCOUNT_NUMBER" => "1234567891",
                          "SETTLEMENT_ACCOUNT_NAME_CODE" => "002",
                          "SUBMISSION_SE_ACCOUNT_NUMBER" => "1234567891",
                          "CHARGE_AMOUNT" => "0000001350{",
                          "CHARGE_DATE" => "20140717",
                          "ROC_REFERENCE_NUMBER" => "1311123     ",
                          "ROC_REFERENCE_NUMBER_CPC" => "               ",
                          "3-DIGIT_CHARGE_AUTHORISATION_CODE" => "128",
                          "CARD_MEMBER_ACCOUNT_NUMBER" => "377064XXXXX5847",
                          "AIRLINE_TICKET_NUMBER" => "              ",
                          "6-DIGIT_CHARGE_AUTHORISATION_CODE" => "123456"
                        }
                      ]
                    }
                  }
                ]
              }
            }
          ]
        }
      end
    end
  end
end
