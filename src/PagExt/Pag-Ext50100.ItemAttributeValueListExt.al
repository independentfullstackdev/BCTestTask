pageextension 50100 ItemAttributeValueListExt extends "Item Attribute Value List"
{

    layout
    {
        modify(Value)
        {
            trigger OnLookup(var Text: Text): Boolean
            begin
                Text := OpenItemAttributeValues;
            end;
        }
    }

    trigger OnAfterGetRecord()
    begin
        ItemAttribute.SetRange(Name, Rec."Attribute Name");
        ItemAttribute.FindFirst();
    end;

    procedure OpenItemAttributeValues() SelectedAttributes: Text
    var
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttributeValuesPage: Page "Item Attribute Values";
    begin
        ItemAttribute.SetRange(Name, Rec."Attribute Name");
        ItemAttribute.FindFirst();
        ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.ID);
        if (ItemAttribute.Type <> ItemAttribute.Type::Option) and ItemAttributeValue.IsEmpty() then
            if Confirm(ChangeToOptionQst) then begin
                ItemAttribute.Validate(Type, ItemAttribute.Type::Option);
                ItemAttribute.Modify;
            end;
        if ItemAttribute.Type = ItemAttribute.Type::Option then begin
            ItemAttributeValuesPage.SetRecord(ItemAttributeValue);
            ItemAttributeValuesPage.SetTableView(ItemAttributeValue);
            ItemAttributeValuesPage.LookupMode(true);
            if ItemAttributeValuesPage.RunModal() = Action::LookupOK then begin
                ItemAttributeValuesPage.SetSelectionFilter(ItemAttributeValue);
                if ItemAttributeValue.FindSet() then
                    repeat
                        SelectedAttributes += ItemAttributeValue.Value + ',';
                    until ItemAttributeValue.Next() = 0;
                SelectedAttributes := CopyStr(SelectedAttributes, 1, StrLen(SelectedAttributes) - 1);
                Rec.Value := SelectedAttributes;
                CustomValidate(SelectedAttributes);
            end;
        end;
    end;

    procedure CustomValidate(SelectedAttributes: Text)
    var
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
    begin
        if not Rec.FindAttributeValue(ItemAttributeValue) then
            Rec.InsertItemAttributeValue(ItemAttributeValue, Rec);

        ItemAttributeValueMapping.SetRange("Table ID", DATABASE::Item);
        ItemAttributeValueMapping.SetRange("No.", RelatedRecordCode);
        ItemAttributeValueMapping.SetRange("Item Attribute ID", ItemAttributeValue."Attribute ID");
        if ItemAttributeValueMapping.FindFirst then begin
            ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
            ItemAttributeValueMapping.Modify();
        end;
        ItemAttribute.Get(Rec."Attribute ID");
        if ItemAttribute.Type <> ItemAttribute.Type::Option then
            if Rec.FindAttributeValueFromRecord(ItemAttributeValue, xRec) then
                if not ItemAttributeValue.HasBeenUsed then
                    ItemAttributeValue.Delete();
    end;

    var
        ItemAttribute: Record "Item Attribute";
        ChangeToOptionQst: Label 'Predefined values can be defined only for item attributes of type Option.\\Do you want to change the type of this item attribute to Option?';
}
