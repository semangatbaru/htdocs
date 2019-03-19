<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Belajar extends CI_Controller {

	public function index()
	{
		echo "ini method index pada controler belajar";
	}
	public function halo()
	{
		$data = array(
			'judul' => "Cara Membuat View Pada CodeIgniter",
			'tutorial' => "CodeIgniter",
			'creator' => "M. Toriq"
			);
		$this->load->view('view_belajar', $data);
	}
}
