reportextension 50100 SalesInvoiceReportExt extends 1306
{
    WordLayout = 'Layout\SalesInvoice.docx';
    RDLCLayout = 'Layout\SalesInvoice.rdl';

    dataset
    {
        add(Line)
        {
            column(Attributes; Attributes)
            {
            }
        }
    }
}
