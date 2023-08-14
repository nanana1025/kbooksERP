package kbookERP.spring.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

import kbookERP.core.xmlvo.menu.Menu;
import kbookERP.util.Utils;

public class SiteMeshFilter extends ConfigurableSiteMeshFilter{

	private String systemId;
	private String menuPath;

	public SiteMeshFilter(String systemId, String menuPath) {
		this.systemId = systemId;
		this.menuPath = menuPath;
	}

	@Override
	public void applyCustomConfiguration(SiteMeshFilterBuilder builder){

//		String fileName = systemId + "_MENU.xml";
//		String adminFileName = "admin_MENU_M.xml";
//        String menuFilePath = Utils.getMenuFilePath(fileName, menuPath);
//        String adminMenuFilePath = Utils.getMenuAdmFilePath(adminFileName, menuPath);
//		Menu menu;
//		Menu adminMenu;
		System.out.println("***************************");
		System.out.println("필터수행");
//		System.out.println("systemId : "+systemId);
//		System.out.println("menuFilePath : "+menuFilePath);
//		System.out.println("adminMenuFilePath : "+adminMenuFilePath);
		System.out.println("***************************");
		try {
//			menu = Utils.getMenuXmlToObject(menuFilePath);
//			adminMenu = Utils.getMenuXmlToObject(adminMenuFilePath);
		} catch (Exception e) {
			System.out.println("#####MENU XML load 실패#####");
			return;
		}

//        String menuMode = menu.getType().toLowerCase();
//        String adminMenuMode = adminMenu.getType().toLowerCase();
        System.out.println("***************************");
//        System.out.println("menuMode : "+menuMode);
//        System.out.println("adminMenuMode : "+adminMenuMode);
        System.out.println("***************************");

        //user
//        if("top".equals(menuMode)) {
//        	builder.addDecoratorPath("/layout.do*", "/WEB-INF/decorator/topLayout.jsp");
//        	builder.addDecoratorPath("/layoutCustom.do*", "/WEB-INF/decorator/topLayout.jsp");
//        } else { //left
//        	builder.addDecoratorPath("/layout.do*", "/WEB-INF/decorator/leftLayout.jsp");
//        	builder.addDecoratorPath("/layoutCustom.do*", "/WEB-INF/decorator/leftLayout.jsp");
//        }
//        //admin
//        if("top".equals(adminMenuMode)) {
//        	builder.addDecoratorPath("/admin/layout.do*", "/WEB-INF/decorator/topLayout.jsp");
//        	builder.addDecoratorPath("/admin/layoutCustom.do*", "/WEB-INF/decorator/topLayout.jsp");
//        } else { //left
//        	builder.addDecoratorPath("/admin/layout.do*", "/WEB-INF/decorator/leftLayout.jsp");
//        	builder.addDecoratorPath("/admin/layoutCustom.do*", "/WEB-INF/decorator/leftLayout.jsp");
//        }

        /* 팝업 */
//        builder.addDecoratorPath("/*SaveP.do*", "/WEB-INF/decorator/savePLayout.jsp")
//        	   .addDecoratorPath("/*SelectP.do*", "/WEB-INF/decorator/selectPLayout.jsp")
//        	   .addDecoratorPath("/*NewW.do*", "/WEB-INF/decorator/newWLayout.jsp")
//        	   .addDecoratorPath("/*NewList.do*", "/WEB-INF/decorator/newListLayout.jsp")
//        	   .addDecoratorPath("/*SearchP.do*", "/WEB-INF/decorator/searchPLayout.jsp")
//        	   .addDecoratorPath("/*CustomP.do*", "/WEB-INF/decorator/customPLayout.jsp")
//        		.addDecoratorPath("/*CustomPP.do*", "/WEB-INF/decorator/customPPLayout.jsp");
//
//        /* 제외 */
	    builder.addExcludedPath("/login.do").addExcludedPath("/logout.do");
//	    	   .addExcludedPath("/systemSel.do")/*.addExcludedPath("/member/admNewMember.do")
//	    	   .addExcludedPath("/member/admUserFindIdView.do").addExcludedPath("/member/admUserPasswordFindView.do");*/
//	    	   .addExcludedPath("/admNewMember.do").addExcludedPath("/admNewCompany.do").addExcludedPath("/admNewMemberType.do").addExcludedPath("/userFindIdView.do").addExcludedPath("/userPasswordFindView.do");
    }
}
