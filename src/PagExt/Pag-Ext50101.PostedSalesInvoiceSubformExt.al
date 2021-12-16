pageextension 50101 PostedSalesInvoiceSubformExt extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field(Attributes; Rec.Attributes)
            {
                ApplicationArea = All;
            }
        }
    }
}
