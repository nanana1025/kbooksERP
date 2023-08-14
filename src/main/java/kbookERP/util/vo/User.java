package kbookERP.util.vo;

public class User {

    private String user_seq;
    private String user_id;
    private String login_id;
    private String user_nm;
    private String passwd;
    private String job_rank_cd;
    private String mobile;
    private String state_cd;
    private String use_yn;
    private String auth_id;
    private String create_dt;

    private String user_type_cd;
    private String company_cd;
    private String company_id;
    private String dept_cd;
    private String email;
    private String tel;
    private String recommender_id;


	public String getUser_type_cd() {
		return user_type_cd;
	}

	public void setUser_type_cd(String user_type_cd) {
		this.user_type_cd = user_type_cd;
	}

	public String getCompany_id() {
		return company_id;
	}

	public void setCompany_id(String company_id) {
		this.company_id = company_id;
	}

	public String getCompany_cd() {
		return company_cd;
	}

	public void setCompany_cd(String company_cd) {
		this.company_cd = company_cd;
	}

	public String getDept_cd() {
		return dept_cd;
	}

	public void setDept_cd(String dept_cd) {
		this.dept_cd = dept_cd;
	}
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getRecommender_id() {
		return recommender_id;
	}

	public void setRecommender_id(String recommender_id) {
		this.recommender_id = recommender_id;
	}

    public String getLogin_id() {
		return login_id;
	}

	public void setLogin_id(String login_id) {
		this.login_id = login_id;
		this.user_id = login_id;
	}

	public String getJob_rank_cd() {
		return job_rank_cd;
	}

	public void setJob_rank_cd(String job_rank_cd) {
		this.job_rank_cd = job_rank_cd;
	}

	public String getAuth_id() {
        return auth_id;
    }

    public void setAuth_id(String auth_id) {
        this.auth_id = auth_id;
    }

    public String getUser_seq() {
        return user_seq;
    }

    public void setUser_seq(String user_seq) {
        this.user_seq = user_seq;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
        this.login_id = user_id;
    }

    public String getUser_nm() {
        return user_nm;
    }

    public void setUser_nm(String user_nm) {
        this.user_nm = user_nm;
    }

    public String getPasswd() {
        return passwd;
    }

    public void setPasswd(String passwd) {
        this.passwd = passwd;
    }

	public String getState_cd() {
		return state_cd;
	}

	public void setState_cd(String state_cd) {
		this.state_cd = state_cd;
	}

	public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getUse_yn() {
        return use_yn;
    }

    public void setUse_yn(String use_yn) {
        this.use_yn = use_yn;
    }

	public String getCreate_dt() {
		return create_dt;
	}

	public void setCreate_dt(String create_dt) {
		this.create_dt = create_dt;
	}

}
