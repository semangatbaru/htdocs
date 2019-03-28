<?php
    public function cek_login() {
            if($this->CI->session->userdata('nama') == '') {
            $this->CI->session->set_flashdata('sukses','Anda belum login');
            redirect(base_url('index.php/login'));
            }
    }
?>