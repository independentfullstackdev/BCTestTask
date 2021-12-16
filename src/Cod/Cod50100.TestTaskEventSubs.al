codeunit 50100 TestTaskEventSubs
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure BeforeSalesInvLineInsert(SalesLine: Record "Sales Line"; var SalesInvLine: Record "Sales Invoice Line")
    var
        Item: Record Item;
        ItemAttributeValueSelection: Record "Item Attribute Value Selection" temporary;
    begin
        if SalesLine.Type = SalesLine.Type::Item then begin
            if Item.Get(SalesLine."No.") then begin
                PopulateItemAttributeValueSelection(ItemAttributeValueSelection, Item);
                ItemAttributeValueSelection.Reset();
                ItemAttributeValueSelection.SetCurrentKey("Inherited-From Table ID", "Inherited-From Key Value");
                ItemAttributeValueSelection.SetRange("Inherited-From Table ID", Database::Item);
                ItemAttributeValueSelection.SetRange("Inherited-From Key Value", Item."No.");
                if ItemAttributeValueSelection.FindSet() then
                    repeat
                        if ItemAttributeValueSelection.Value.Contains(',') then
                            SalesInvLine.Attributes := ItemAttributeValueSelection.Value;
                    until ItemAttributeValueSelection.Next() = 0;
            end;
        end;
    end;

    local procedure PopulateItemAttributeValueSelection(var ItemAttributeValueSelection: Record "Item Attribute Value Selection" temporary; Item: Record Item)
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        TempItemAttributeValue: Record "Item Attribute Value" temporary;
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        ItemAttributeValueMapping.SetRange("Table ID", DATABASE::Item);
        ItemAttributeValueMapping.SetRange("No.", Item."No.");
        if ItemAttributeValueMapping.FindSet then
            repeat
                ItemAttributeValue.Get(ItemAttributeValueMapping."Item Attribute ID", ItemAttributeValueMapping."Item Attribute Value ID");
                TempItemAttributeValue.TransferFields(ItemAttributeValue);
                TempItemAttributeValue.Insert();
            until ItemAttributeValueMapping.Next() = 0;
        ItemAttributeValueSelection.PopulateItemAttributeValueSelection(TempItemAttributeValue, DATABASE::Item, Item."No.");
    end;
}
