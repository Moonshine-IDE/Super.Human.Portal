package classes.validators
{
    import model.vo.CountriesDataModelVO;

    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IPopUpHost;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.beads.models.DropDownListModel;
    import org.apache.royale.jewel.beads.validators.Validator;
    import org.apache.royale.utils.UIUtils;
        
	public class CountryCodeDropDownListSelectionRequireValidator extends Validator
	{
		public function CountryCodeDropDownListSelectionRequireValidator()
		{
			super();
		}
	
		override public function validate(event:Event = null):Boolean 
		{
			var providerModel:DropDownListModel = hostComponent['getBeadByType'](IDataProviderModel) as DropDownListModel;
			if (providerModel)
			{
				var dataProvider:ArrayList = providerModel.dataProvider as ArrayList;
				if (!dataProvider || dataProvider.length == 0)
				{
					return false;
				}
				
				var countryCode:CountriesDataModelVO = providerModel.selectedItem as CountriesDataModelVO;
	
				if (countryCode && countryCode.countryID > -1) 
				{
					var host:IPopUpHost = UIUtils.findPopUpHost(hostComponent);
					(host as IUIBase).dispatchEvent(new Event("cleanValidationErrors"));
					return true;
				}
				else 
				{
					createErrorTip(requiredFieldError);
				} 
			}
			
			return false;
		}	
	}
}