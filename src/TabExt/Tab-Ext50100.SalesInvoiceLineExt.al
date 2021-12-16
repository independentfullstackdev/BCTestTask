tableextension 50100 SalesInvoiceLineExt extends "Sales Invoice Line"
{
    fields
    {
        field(50100; Attributes; Text[250])
        {
            Caption = 'Attributes';
            DataClassification = CustomerContent;
        }

    }
}
