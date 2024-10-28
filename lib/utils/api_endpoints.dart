class ApiEndpoints {
  static const login = "/Mobile/Loginwithpin";
  static const homeJobsCount = "/Mobile/DailyCounts";
  static const jobDetails = "/jobadmindashboard/jobdetails";
  static const jobAttachments = "/ImageReadandSave/Read";
  static const updateImage = "/ImageReadandSave/UserSave";
  static const updateAttachment = "/ImageReadandSave/Save";
  static const productListDetail = "/JobProductAPI";
  static const printerProductServicesList = "/jobservicelist/printer";
  static const fabricatorProductServicesList = "/jobservicelist/febrication";
  static const dropdownDesigner = "/UserDropdownAPI/Designer/";
  static const dropdownPrinter = "/UserDropdownAPI/Printing/";
  static const dropdownFabrication = "/UserDropdownAPI/Fabrication/";
  static const dropdownVendor = "/UserDropdownAPI/Vendor";
  static const dropdownCustomer = "/jobCustomerAPI";
  static const dropdownLocations = "/Mobile/ddlstoragelocation";
  static const dropdownPaymentMode = "/Mobile/PaymentMode";
  static const dropdownYears = "/Mobile/year";
  static const createEditJob = "/jobsld";
  static const updateTime = "/jobstatus/UpdateDesignEndTime";

  // Update API for Designer, Printer, Fabricator, Vendor
  static const designReady = "/jobstatus/UpdateDesignready";
  static const updateDesigner = "/jobstatus/UpdateDesign";
  static const updatePrinter = "/jobstatus/UpdatePrinting";
  static const updateFabricator = "/jobstatus/Updatefabrication";
  static const updateVendor = "/jobstatus/Updateother";

  // Assign API for Designer, Printer, Fabricator, Vendor
  static const assignToDesigner = "/jobstatus/AssignDesign";
  static const assignToPrinter = "/jobstatus/Assignprinting";
  static const assignToFabrication = "/jobstatus/Assignfabrication";
  static const assignToVendor = "/jobstatus/Assignother";

  // Edit Job Details API
  static const saveLabel = "/jobstatus/Savelabel";
  static const deleteLabel = "/jobstatus/Deletelabel";
  static const updateDueDate = "/jobstatus/UpdateDuedate";
  static const updateLink = "/jobstatus/UpdateLink";
  static const updateDesignCost = "/jobstatus/UpdateDesigncost";
  static const updateQty = "/jobstatus/Updateqty";
  static const readyToDispatch = "/jobstatus/AssignUpdate";
  static const dispatchToCustomer = "/jobstatus/UpdateUpdate";
  static const advanceAndApproveUpdate = "/jobstatus/UpdateAdvance";

  // Chat API
  static const chatDetails = "/Mobile/Initiatechat";
  static const sendChatText = "/Mobile/ChatMessage";
  static const sendChatAttachment = "/Mobile/ChatAttached";

  // Admin API
  static const adminJobsCount = "/jobadmindashboard/pending";
  static const adminTodayCount = "/jobadmindashboard/today";
  static const adminDashboardJobs =
      "/jobadmindashboard/apppendingjobtilldispatch";
  static const adminInquiryNumber = "/JobInquiryEntryAPI/Inquiryno";
  static const adminInquiryEntry = "/Mobile/jobInquiryEntry";
  static const adminInquiryDelete = "/JobInquiryEntryAPI";
  static const adminInquiryList = "/Mobile/GetInquiryList";
  static const adminInquiryById = "/JobInquiryEntryAPI";
  static const adminInquiryFollowUpList = "/JobInquiryFollowUpAPI";
  static const adminInquiryFollowUpDelete = "/JobInquiryFollowUpAPI";
  static const adminInquiryFollowUpSave = "/JobInquiryFollowUpAPI";
  static const adminInquiryFollowUpUpdate = "/JobInquiryFollowUpAPI";
  static const adminGraph = "/Mobile/MontlySale";
  static const customerDetails = "/ReadCustomerAPI";

  // Reports
  static const rInDesign = "/jobwip/Indesign";
  static const rInPrinting = "/jobwip/Inprinting";
  static const rInFabrication = "/jobwip/Infabrication";
  static const rReadyDispatch = "/jobwip/Readyfordispatch";
  static const rJobAtVendor = "/jobwip/Invendor";
  static const rUnassigned = "/jobwip/Unassignedjob";
  static const rDesignerCollection = "/Reports/MonthlyDesignercollection";
  static const rDatewiseCustomer = "/Reports/DatewiseCustomerJobReports";

  static String allPendingJobs(String userType) {
    String url;

    if (userType == "Designer") {
      url = "/JobDesignerAPI/allpendingforDesign";
    } else if (userType == "Printing") {
      url = "/JobPrintingAPI/allpendingforPrinting";
    } else if (userType == "Fabrication") {
      url = "/JobFabricationAPI/allpendingforfabrication";
    } else if (userType == "Dispatch") {
      url = "/JobDispatchAPI/allpendingfordispatch";
    } else if (userType == "Vendor") {
      url = "/JobVendor/allpendingatvendor";
    } else if (userType == "Customer") {
      url = "/JobCustomerDashboard/joblisttilldispatch";
    }else if (userType == "Just4u") {
      url = "/Mobile/GetInquiryList";
    } else {
      url = "";
    }

    return url;
  }

  static String newJobsToday(String userType) {
    String url;

    if (userType == "Designer") {
      url = "/JobDesignerAPI/newjobtoday";
    } else if (userType == "Printing") {
      url = "/JobPrintingAPI/newjobtoday";
    } else if (userType == "Fabrication") {
      url = "/JobFabricationAPI/newjobtoday";
    } else if (userType == "Dispatch") {
      url = "/JobDispatchAPI/newjobtoday";
    } else if (userType == "Vendor") {
      url = "/JobVendor/newjobtoday";
    } else if (userType == "Customer") {
      url = "/JobCustomerDashboard/newjobtoday";
    } else {
      url = "";
    }

    return url;
  }

  static String pendingJobsToday(String userType) {
    String url;

    if (userType == "Designer") {
      url = "/JobDesignerAPI/previouspendingjobs";
    } else if (userType == "Printing") {
      url = "/JobPrintingAPI/previouspendingjobs";
    } else if (userType == "Fabrication") {
      url = "/JobFabricationAPI/previouspendingjobs";
    } else if (userType == "Dispatch") {
      url = "/JobDispatchAPI/previouspendingjobs";
    } else if (userType == "Vendor") {
      url = "/JobVendor/previouspendingjobs";
    } else if (userType == "Customer") {
      url = "/JobCustomerDashboard/previouspendingjobs";
    } else {
      url = "";
    }

    return url;
  }

  static String completedJobsToday(String userType) {
    String url;

    if (userType == "Designer") {
      url = "/JobDesignerAPI/todaycompletedjobs";
    } else if (userType == "Printing") {
      url = "/JobPrintingAPI/todaycompletedjobs";
    } else if (userType == "Fabrication") {
      url = "/JobFabricationAPI/todaycompletedjobs";
    } else if (userType == "Dispatch") {
      url = "/JobDispatchAPI/allcompletedjobs";
    } else if (userType == "Vendor") {
      url = "/JobVendor/allcompletedjobs";
    } else if (userType == "Customer") {
      url = "/JobCustomerDashboard/allcompletedjobs";
    } else {
      url = "";
    }

    return url;
  }
}
